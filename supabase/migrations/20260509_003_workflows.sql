create table workflows (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references tenants(id) on delete cascade,
  name text not null,
  description text,
  target_entity_id text,
  trigger_type text not null,
  trigger_config jsonb,
  agent_config jsonb not null,
  output_config jsonb not null,
  a2a_exposed boolean default false,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table workflow_runs (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references tenants(id) on delete cascade,
  workflow_id uuid not null references workflows(id) on delete cascade,
  status text not null,
  trigger_source text,
  input jsonb,
  output jsonb,
  trivium_trace jsonb,
  cost_usd numeric(10,4),
  duration_ms int,
  started_at timestamptz default now(),
  completed_at timestamptz
);

create table ai_builder_history (
  id bigserial primary key,
  tenant_id uuid not null references tenants(id) on delete cascade,
  user_id uuid references auth.users(id),
  prompt text not null,
  generated_config_diff jsonb,
  applied boolean default false,
  applied_at timestamptz,
  created_at timestamptz default now()
);
