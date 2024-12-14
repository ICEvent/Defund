import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export type Currency = { 'ICP' : null } |
  { 'ckBTC' : null } |
  { 'ckETH' : null } |
  { 'ckUSDC' : null };
export type Currency__1 = { 'ICP' : null } |
  { 'ckBTC' : null } |
  { 'ckETH' : null } |
  { 'ckUSDC' : null };
export interface Donation {
  'donorId' : Principal,
  'txid' : string,
  'currency' : Currency,
  'timestamp' : bigint,
  'amount' : bigint,
}
export interface Grant {
  'applicant' : Principal,
  'grantStatus' : Status,
  'title' : string,
  'submitime' : bigint,
  'recipient' : Principal,
  'votingStatus' : [] | [VotingStatus],
  'description' : string,
  'grantId' : bigint,
  'currency' : Currency__1,
  'category' : string,
  'proofs' : Array<string>,
  'amount' : bigint,
}
export interface NewGrant {
  'title' : string,
  'recipient' : Principal,
  'description' : string,
  'currency' : Currency__1,
  'category' : string,
  'proofs' : Array<string>,
  'amount' : bigint,
}
export interface PowerChange {
  'source' : Donation,
  'timestamp' : bigint,
  'amount' : bigint,
}
export type Result = { 'ok' : bigint } |
  { 'err' : string };
export type Status = { 'review' : null } |
  { 'cancelled' : null } |
  { 'expired' : null } |
  { 'submitted' : null } |
  { 'voting' : null } |
  { 'approved' : null } |
  { 'rejected' : null };
export interface Vote {
  'voteType' : VoteType,
  'grantId' : bigint,
  'voterId' : Principal,
  'votePower' : bigint,
  'timestamp' : bigint,
}
export type VoteType = { 'reject' : null } |
  { 'approve' : null };
export interface VotingPower {
  'userId' : Principal,
  'totalPower' : bigint,
  'powerHistory' : Array<PowerChange>,
}
export interface VotingStatus {
  'startTime' : bigint,
  'rejectVotePower' : bigint,
  'endTime' : bigint,
  'votes' : Array<Vote>,
  'approvalVotePower' : bigint,
  'totalVotePower' : bigint,
}
export interface _SERVICE {
  'applyGrant' : ActorMethod<[NewGrant], Result>,
  'cancelGrant' : ActorMethod<[bigint], Result>,
  'donate' : ActorMethod<[bigint, Currency, string], Result>,
  'finalizeGrantVoting' : ActorMethod<[bigint], Result>,
  'getAllGrants' : ActorMethod<[], Array<Grant>>,
  'getDonorCredit' : ActorMethod<[string], [] | [bigint]>,
  'getGrant' : ActorMethod<[bigint], [] | [Grant]>,
  'getGrantVotingStatus' : ActorMethod<[bigint], [] | [VotingStatus]>,
  'getGrants' : ActorMethod<[Array<Status>, bigint], Array<Grant>>,
  'getMyGrants' : ActorMethod<[], Array<Grant>>,
  'getVotingPower' : ActorMethod<[Principal], [] | [VotingPower]>,
  'startGrantVoting' : ActorMethod<[bigint], Result>,
  'updateExchangeRates' : ActorMethod<[Currency, bigint], Result>,
  'voteOnGrant' : ActorMethod<[bigint, VoteType], Result>,
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
