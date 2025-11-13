# Hardened-4626-Vault (Enhanced ERC-4626 Vault)

## 1. Project Vision
The goal of this project is to build a hardened, tokenized vault that fully complies with the ERC-4626 standard.  
This vault is designed with **production-grade security** as the top priority.  
Its architecture explicitly and verifiably mitigates six of the most critical vulnerability classes in DeFi, making it a **security-first engineering effort**.

## 2. Core Features
The vault strictly follows the ERC-4626 interface and provides the following core functions:

- `deposit(uint256 assets, ...)`
- `mint(uint256 shares, ...)`
- `withdraw(uint256 assets, ...)`
- `redeem(uint256 shares, ...)`

Additionally, it includes a separate contract `SimpleStrategy.sol` to simulate yield farming, with a `harvest()` function for strategy execution.

## 3. Core Security Considerations
The vault’s design hardens against six major security threats:

### Hardening Strategy

1. **Reentrancy Attacks**  
   - All functions involving state changes and external transfers (`deposit`, `withdraw`, etc.) strictly follow the **Checks-Effects-Interactions (CEI)** pattern.  
   - Full use of OpenZeppelin’s `nonReentrant` guard.

2. **Price Oracle Manipulation / Inflation Attack**  
   - To prevent the classic ERC-4626 “inflation attack,” the vault seeds liquidity during contract construction.  
   - This permanently resolves the “first depositor” exploit where share price can be manipulated.

3. **Logic vs. Ledger Separation**  
   - Inspired by DVDF #1 (*Unstoppable*), the vault’s `totalAssets()` does not rely on `asset.balanceOf(address(this))`.  
   - Instead, it maintains a robust internal ledger to prevent “toxic token” contamination.

4. **Integer Overflow / Underflow**  
   - Special handling for decimal mismatches (e.g., 18-decimal shares vs. 6-decimal USDC).  
   - Strict adherence to the defensive math principle: **rounding always favors the vault**.

5. **Improper Access Control**  
   - The vault does not use `Ownable`.  
   - Instead, it implements OpenZeppelin’s `AccessControl`, defining multiple roles such as `ADMIN_ROLE` and `STRATEGIST_ROLE`.

6. **Arbitrary Calldata Exploits**  
   - Learning from DVDF #3 (*Truster*), the vault disallows strategists from passing arbitrary calldata when calling strategies.  
   - `harvest()` only calls a predefined, parameterless `strategy.execute()` interface.

## 4. Contract Architecture
- **HardenedVault.sol**: The core ERC-4626 vault contract.  
- **SimpleStrategy.sol**: A minimal strategy contract simulating external yield sources.  
