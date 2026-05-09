create table tentant_configs (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references tenants(id) on delete cascade,
  version int not null,
  config jsonb not null,
  created_at timestamptz default now(),
  created_by uuid references auth.users(id),
  unique (tenant_id, version)
);

create table entities (
  tenant_id uuid not null references tenants(id) on delete cascade,
  entity_id text not null,
  display_name text not null,
  schema jsonb not null,
  mcp_exposed boolean default true,
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  primary key (tenant_id, entity_id)
);

create table entity_records (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references tenants(id) on delete cascade,
  entity_id text not null,
  data jsonb not null,
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  created_by uuid references auth.users(id),
  updated_by uuid references auth.users(id),
  foreign key (tenant_id, entity_id) references entities(tenant_id, entity_id) on delete cascade
);

create table entity_record_history (
  id bigserial primary key,
  tenant_id uuid not null references tenants(id) on delete cascade,
  entity_id text not null,
  record_id uuid not null,
  changed_at timestamptz default now(),
  changed_by uuid references auth.users(id),
  change_type text check (change_type in ('create','update','delete')),
  diff jsonb
);

-- RLS and updated_at triggers would go here
