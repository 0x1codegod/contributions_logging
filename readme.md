# Contribution Tracking Program

This is a Solana program built using the Anchor framework to track contributions and distribute rewards based on contribution levels and types. The program assigns points for various types of contributions and uses these points to calculate token rewards.

---

## Features

1. **Log Contributions**
   - Allows contributors to log their contributions with details such as type and level.
   - Points are awarded based on the contribution type and level.

2. **Distribute Tokens**
   - Distributes tokens proportionally to contributors based on the total points they have accumulated.

3. **Custom Contribution Types and Levels**
   - Supports multiple types and levels of contributions, such as Bug Fixes, Feature Development, and Test Contributions.

---

## Program Structure

### Program Modules

- **`log_contribution`**
   - Logs a contribution and updates the contributor's total points.
- **`distribute_tokens`**
   - Calculates token rewards and performs the distribution to contributors.

### Helper Function

- **`get_points`**
   - Calculates the points to award based on the type and level of contribution.

### Data Types

#### ContributionType
```rust
pub enum ContributionType {
    BugFix,
    FeatureDevelopment,
    CodeOptimization,
    BugReporting,
    TestContributions,
}
```

#### ContributionLevel
```rust
pub enum ContributionLevel {
    Minor,
    Medium,
    Major,
    Critical,
    ExploitDiscovery,
    Simple,
    Complex,
    Basic,
    TestCase,
}
```

#### Contribution Account
```rust
pub struct Contribution {
    pub contributor: Pubkey,
    pub points: u64,
}
```

---

## How to Run the Program

### Prerequisites

1. Install [Anchor](https://project-serum.github.io/anchor/getting-started/installation.html).
2. Install Rust and Solana CLI tools.

### Build and Deploy

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd contribution-tracking
   ```

2. **Build the Program**
   ```bash
   anchor build
   ```

3. **Deploy the Program**
   ```bash
   anchor deploy
   ```

### Testing

Run tests to verify the program's functionality:
```bash
anchor test
```

---

## Usage

### Logging Contributions
Call the `log_contribution` instruction with the following parameters:
- `contributor`: The public key of the contributor.
- `contribution_type`: The type of contribution.
- `level`: The level of contribution.

### Distributing Tokens
Call the `distribute_tokens` instruction with the following parameters:
- `total_points`: The total points accumulated by all contributors.
- `token_pool`: The total number of tokens available for distribution.

---

## Example

### Logging a Contribution
```rust
log_contribution(
    ctx,
    contributor_pubkey,
    ContributionType::BugFix,
    ContributionLevel::Critical,
)?;
```

### Distributing Tokens
```rust
distribute_tokens(
    ctx,
    total_points,
    token_pool,
)?;
```

---

## License

This program is open-source and available under the MIT License. See the `LICENSE` file for more information.

---

## Acknowledgements

- Built with the [Anchor Framework](https://project-serum.github.io/anchor/).
- Inspired by decentralized reward systems for community contributions.
