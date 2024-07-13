import Types "types";
import Array "mo:base/Array";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Time "mo:base/Time";
import Order "mo:base/Order";
import Buffer "mo:base/Buffer";
import Result "mo:base/Result";

import Principal "mo:base/Principal";
import TrieMap "mo:base/TrieMap";

actor {type Donation = Types.Donation;
type Grant = Types.Grant;

stable var donations : [Donation] = [];
stable var upgradeCredits : [(Principal, Nat)] = [];
stable var upgradeExchangeRates : [(Text, Nat)] = [];
stable var grants : [Grant] = [];
stable var DEFAULT_PAGE_SIZE = 10;

var donorCredits = TrieMap.TrieMap<Principal, Nat>(Principal.equal, Principal.hash);
donorCredits := TrieMap.fromEntries<Principal, Nat>(Iter.fromArray(upgradeCredits), Principal.equal, Principal.hash);
var donorExchangeRates = TrieMap.TrieMap<Text, Nat>(Text.equal, Text.hash);
donorExchangeRates := TrieMap.fromEntries<Text, Nat>(Iter.fromArray(upgradeExchangeRates), Text.equal, Text.hash);

system func preupgrade() {
	upgradeCredits := Iter.toArray(donorCredits.entries());
	upgradeExchangeRates := Iter.toArray(donorExchangeRates.entries());
};

system func postupgrade() {
	upgradeCredits := [];
	upgradeExchangeRates := [];
};

public shared ({ caller }) func updateExchangeRates(currency : Text, rate : Nat) : async Result.Result<Nat, Text> {
	if (Principal.isAnonymous(caller)) {
		#err("no permission for anonymous caller to set exchange rate");
	} else {
		donorExchangeRates.put(currency, rate);
		#ok(1);
	};
};
// Add a new donation
public shared ({ caller }) func donate(amount : Nat, currency : Text, payment : { #block:Nat; #txid:Text }) : async Result.Result<Nat, Text> {
	if (Principal.isAnonymous(caller)) {
		#err("no permission for anonymous caller to donate");
	} else {
		let bdonations : Buffer.Buffer<Donation> = Buffer.fromArray(donations);
		try {
			switch (payment) {
				case (#block(block)) {
					//TODO: check block is valid
				};
				case (#txid(txid)) {

					//TODO: check transaction is valid
					bdonations.add({
						timestamp = Time.now();
						donor = caller;
						amount = amount;
						currency = currency;
						txid = txid;
					});
				};
			};
				donations := Buffer.toArray(bdonations);

				// Update donor's credit
				let currentCredit = donorCredits.get(caller);
				donorCredits.put(
					caller,
					switch (currentCredit) {
						case (null) amount;
						case (?credit) credit + amount;
					}
				);

				#ok(1);
			} catch (err) {
				#err("failed to add donation");
			};
		};
	};

	// Fetch donation history by page and donation time
	public query func getDonationHistory(page : Nat, pageSize : Nat, startTime : ?Time.Time, endTime : ?Time.Time) : async [Donation] {
		let filteredDonations = Array.filter<Donation>(
			donations,
			func(d : Donation) {
				let donationTime = d.timestamp;
				switch (startTime, endTime) {
					case (null, null) true;
					case (?start, null) donationTime >= start;
					case (null, ?end) donationTime <= end;
					case (?start, ?end) donationTime >= start and donationTime <= end;
				};
			}
		);
		let sortedDonations = Array.sort(
			filteredDonations,
			func(d1 : Donation, d2 : Donation) : Order.Order {
				if (d1.timestamp > d2.timestamp) { #less } else if (d1.timestamp == d2.timestamp) {
					#equal;
				} else { #greater };
			}
		);
		Array.tabulate<Donation>(
			pageSize,
			func(i) {
				sortedDonations[page * pageSize + i];
			}
		);
	};

	public query func getDonorHistory(donor : Principal, page : Nat) : async [Donation] {
		let filteredDonations = Array.filter<Donation>(donations, func(d) = d.donor == donor);

		let sortedDonations = Array.sort(
			filteredDonations,
			func(d1 : Donation, d2 : Donation) : Order.Order {
				if (d1.timestamp > d2.timestamp) { #less } else if (d1.timestamp == d2.timestamp) {
					#equal;
				} else { #greater };
			}
		);
		Array.tabulate<Donation>(
			DEFAULT_PAGE_SIZE,
			func(i) {
				sortedDonations[page * DEFAULT_PAGE_SIZE + i];
			}
		);
	};

	public query func getDonorCredit(donor : Text) : async ?Nat {
		return donorCredits.get(Principal.fromText(donor));
	};
};
