# Marcelo Registry

📦 A global project registry built in Move for the **Sui blockchain**.

This Move module allows anyone to:
- Register a new project (title + link)
- Update their own projects
- List all registered projects on-chain

## 🧠 How to Use
Deploy this package to Sui testnet or mainnet using:
```bash
sui move build
sui client publish --gas-budget 500000000
