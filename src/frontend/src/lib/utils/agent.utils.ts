import { HttpAgent, type Identity } from '@dfinity/agent';
export type GetAgentParams = { identity: Identity };

export const getAgent = async (params: GetAgentParams): Promise<HttpAgent> => {
	// if (DEV) {
	// 	return getLocalAgent(params);
	// }

	return getMainnetAgent(params);
};

const getMainnetAgent = async (params: GetAgentParams) => {
	const host ='https://icp0.io';
	return new HttpAgent({ ...params, host });
};

const getLocalAgent = async (params: GetAgentParams) => {
	const host = 'http://localhost:5987/';

	const agent: HttpAgent = new HttpAgent({ ...params, host });

	// Fetch root key for certificate validation during development
	await agent.fetchRootKey();

	return agent;
};
