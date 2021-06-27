module.exports = {
	networks: {
	  development: {
		//host: "127.0.0.1",
		host: "192.168.43.125",
		//host: "192.168.42.52",
		port: 7545,
		network_id: "*", // Match any network id
	  },
	  advanced: {
		websockets: true, // Enable EventEmitter interface for web3 (default: false)
	  },
	},
	contracts_build_directory: "./src/abis/",
	compilers: {
	  solc: {
		optimizer: {
		  enabled: true,
		  runs: 200,
		},
	  },
	},
  };
  