use anchor_lang::prelude::*;
use anchor_spl::token::{self, TokenAccount, Transfer};

declare_id!("pVzK6kbnos46SWPbV5AfoeEDH6sH2eZmQyLEXsZbQV7");

#[program]
mod contribution_tracking {
    use super::*;

    pub fn log_contribution(
        ctx: Context<LogContribution>,
        contributor: Pubkey,
        contribution_type: ContributionType,
        level: ContributionLevel,
    ) -> Result<()> {
        let contribution = &mut ctx.accounts.contribution;
        contribution.contributor = contributor;
        contribution.points += get_points(contribution_type, level)?; // Call the helper function
        Ok(())
    }

    pub fn distribute_tokens(
        ctx: Context<DistributeTokens>,
        total_points: u64,
        token_pool: u64,
    ) -> Result<()> {
        let contributor_points = ctx.accounts.contribution.points;
        let proportion = contributor_points as f64 / total_points as f64;
        let reward_tokens = (token_pool as f64 * proportion) as u64;

        let cpi_accounts = Transfer {
            from: ctx.accounts.token_pool_account.to_account_info(),
            to: ctx.accounts.contributor_token_account.to_account_info(),
            authority: ctx.accounts.admin.to_account_info(),
        };

        let cpi_ctx = CpiContext::new(ctx.accounts.token_program.to_account_info(), cpi_accounts);
        token::transfer(cpi_ctx, reward_tokens)?;

        Ok(())
    }
}

// Helper function for calculating points based on contribution type and level
fn get_points(
    contribution_type: ContributionType,
    level: ContributionLevel,
) -> Result<u64> {
    match contribution_type {
        ContributionType::BugFix => match level {
            ContributionLevel::Minor => Ok(1),
            ContributionLevel::Medium => Ok(3),
            ContributionLevel::Major => Ok(6),
            ContributionLevel::Critical => Ok(9),
            _ => Err(error!(ErrorCode::InvalidLevel)),
        },
        ContributionType::FeatureDevelopment => match level {
            ContributionLevel::Simple => Ok(2),
            ContributionLevel::Medium => Ok(5),
            ContributionLevel::Complex => Ok(8),
            _ => Err(error!(ErrorCode::InvalidLevel)),
        },
        ContributionType::CodeOptimization => match level {
            ContributionLevel::Minor => Ok(1),
            ContributionLevel::Medium => Ok(3),
            ContributionLevel::Major => Ok(6),
            _ => Err(error!(ErrorCode::InvalidLevel)),
        },
        ContributionType::BugReporting => match level {
            ContributionLevel::Minor => Ok(1),
            ContributionLevel::Medium => Ok(3),
            ContributionLevel::Critical => Ok(6),
            ContributionLevel::ExploitDiscovery => Ok(9),
            _ => Err(error!(ErrorCode::InvalidLevel)),
        },
        ContributionType::TestContributions => match level {
            ContributionLevel::Basic => Ok(2),
            ContributionLevel::TestCase => Ok(5),
            _ => Err(error!(ErrorCode::InvalidLevel)),
        },
    }
}

// Data structure for a contribution
#[account]
pub struct Contribution {
    pub contributor: Pubkey,
    pub points: u64,
}

// Enum for different contribution types
#[derive(AnchorSerialize, AnchorDeserialize, Clone)]
pub enum ContributionType {
    BugFix,
    FeatureDevelopment,
    CodeOptimization,
    BugReporting,
    TestContributions,
}

// Enum for different contribution levels
#[derive(AnchorSerialize, AnchorDeserialize, Clone)]
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

// Context for logging a contribution
#[derive(Accounts)]
pub struct LogContribution<'info> {
    #[account(mut)]
    pub contribution: Account<'info, Contribution>,
    pub system_program: Program<'info, System>,
}

// Context for distributing tokens
#[derive(Accounts)]
pub struct DistributeTokens<'info> {
    #[account(mut)]
    pub contribution: Account<'info, Contribution>,
    #[account(mut)]
    pub token_pool_account: Account<'info, TokenAccount>,
    #[account(mut)]
    pub contributor_token_account: Account<'info, TokenAccount>,
    pub admin: Signer<'info>,
    pub token_program: Program<'info, token::Token>,
}

// Custom error codes
#[error_code]
pub enum ErrorCode {
    #[msg("Invalid contribution level for the specified contribution type.")]
    InvalidLevel,
}
