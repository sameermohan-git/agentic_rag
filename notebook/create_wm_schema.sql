-- Ensure the schema exists
CREATE SCHEMA IF NOT EXISTS wealth_management;

CREATE TABLE wealth_management.CLIENT (
    client_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    birth_date DATE NOT NULL,
    citizenship VARCHAR(100) NOT NULL,
    residence_country VARCHAR(100) NOT NULL,
    occupation VARCHAR(100) NOT NULL,
    annual_income NUMERIC(15, 2) NOT NULL,
    employer VARCHAR(255),
    industry VARCHAR(100),
    marital_status VARCHAR(50),
    family_size INT,
    dependents_info JSONB,
    risk_profile VARCHAR(50),
    market_experience VARCHAR(50),
    net_worth NUMERIC(20, 2),
    education_level VARCHAR(50),
    preferred_language VARCHAR(50),
    cultural_preferences JSONB
);

CREATE TABLE wealth_management.FINANCIAL_STATUS (
    status_id SERIAL PRIMARY KEY,
    client_id INT REFERENCES wealth_management.CLIENT(client_id) ON DELETE CASCADE,
    monthly_income NUMERIC(15, 2),
    monthly_expenses NUMERIC(15, 2),
    income_sources JSONB,
    expense_breakdown JSONB,
    emergency_fund NUMERIC(20, 2),
    cashflow_surplus NUMERIC(20, 2),
    last_updated DATE
);

CREATE TABLE wealth_management.LIABILITIES (
    liability_id SERIAL PRIMARY KEY,
    client_id INT REFERENCES wealth_management.CLIENT(client_id) ON DELETE CASCADE,
    type VARCHAR(100),
    amount NUMERIC(20, 2),
    interest_rate NUMERIC(5, 2),
    start_date DATE,
    end_date DATE,
    status VARCHAR(50)
);

CREATE TABLE wealth_management.GOALS (
    goal_id SERIAL PRIMARY KEY,
    client_id INT REFERENCES wealth_management.CLIENT(client_id) ON DELETE CASCADE,
    timeframe VARCHAR(50),
    description TEXT,
    target_amount NUMERIC(20, 2),
    target_date DATE,
    status VARCHAR(50),
    progress NUMERIC(5, 2),
    priority_level VARCHAR(50)
);

CREATE TABLE wealth_management.INSURANCE (
    insurance_id SERIAL PRIMARY KEY,
    client_id INT REFERENCES wealth_management.CLIENT(client_id) ON DELETE CASCADE,
    type VARCHAR(100),
    coverage_amount NUMERIC(20, 2),
    premium NUMERIC(15, 2),
    expiry_date DATE,
    provider VARCHAR(255),
    beneficiaries TEXT
);

CREATE TABLE wealth_management.TAX_PROFILE (
    tax_id SERIAL PRIMARY KEY,
    client_id INT REFERENCES wealth_management.CLIENT(client_id) ON DELETE CASCADE,
    tax_bracket VARCHAR(50),
    tax_accounts JSONB,
    filing_status VARCHAR(50),
    deductions JSONB,
    tax_residence VARCHAR(100)
);

CREATE TABLE wealth_management.ESTATE_PLANNING (
    estate_id SERIAL PRIMARY KEY,
    client_id INT REFERENCES wealth_management.CLIENT(client_id) ON DELETE CASCADE,
    has_will BOOLEAN,
    will_last_updated DATE,
    trust_details JSONB,
    beneficiaries JSONB,
    power_of_attorney VARCHAR(255),
    healthcare_directive VARCHAR(255)
);

CREATE TABLE wealth_management.LIFESTYLE (
    lifestyle_id SERIAL PRIMARY KEY,
    client_id INT REFERENCES wealth_management.CLIENT(client_id) ON DELETE CASCADE,
    travel_preferences JSONB,
    hobbies JSONB,
    education_plans JSONB,
    monthly_discretionary NUMERIC(15, 2),
    retirement_lifestyle JSONB
);

CREATE TABLE wealth_management.PORTFOLIO (
    portfolio_id SERIAL PRIMARY KEY,
    client_id INT REFERENCES wealth_management.CLIENT(client_id) ON DELETE CASCADE,
    total_value NUMERIC(20, 2),
    last_rebalance DATE,
    strategy_type VARCHAR(100),
    target_return NUMERIC(5, 2),
    current_return NUMERIC(5, 2),
    risk_score NUMERIC(5, 2),
    esg_preferences JSONB,
    sector_allocation JSONB,
    geographic_allocation JSONB
);

CREATE TABLE wealth_management.MARKET_VIEWS (
    view_id SERIAL PRIMARY KEY,
    client_id INT REFERENCES wealth_management.CLIENT(client_id) ON DELETE CASCADE,
    economic_outlook JSONB,
    sector_preferences JSONB,
    risk_concerns JSONB,
    investment_interests JSONB,
    last_updated DATE
);

CREATE TABLE wealth_management.ML_INSIGHTS (
    insight_id SERIAL PRIMARY KEY,
    client_id INT REFERENCES wealth_management.CLIENT(client_id) ON DELETE CASCADE,
    model_type VARCHAR(100),
    prediction_results JSONB,
    confidence_score NUMERIC(5, 2),
    generation_date DATE,
    next_best_actions JSONB,
    churn_risk JSONB,
    investment_suggestions JSONB
);