module.exports = {
  networks: {
    development: {
      host: "0.0.0.0",
      port: 7545,
      network_id: "*",
    },
  },
  contracts_directory: "./build/contracts",
  compilers: {
    solc: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },

  db: {
    enabled: false,
  },
};