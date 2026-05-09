-- Tenants and Members
create table tenants (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text unique not null,
  plan text not null default 'starter',
  locale text not null default 'ja',
  timezone text not null default 'Asia/Tokyo',
  stripe_customer_id text,
  stripe_subscription_id text,
  created_at timestamptz default now(),
  deleted_at timestamptz
);

create table tenant_members (
  tenant_id uuid references tenants(id) on delete cascade,
  user_id uuid references auth.users(id) on delete cascade,
  role text not null check (role in ('admin','editor','viewer')),
  created_at timestamptz default now(),
  primary key (tenant_id, user_id)
);

-- RLS
alter table tenants enable row level security;
alter table tenant_members enable row level security;

create policy "Tenants are visible to members" on tenants for select
  using (exists (select 1 from tenant_members where tenant_id = tenants.id and user_id = auth.uid()));
create policy "Members are visible to fellow members" on tenant_members for select
  using (exists (select 1 from tenant_members tm where tm.tenant_id = tenant_members.tenant_id and tm.user_id = auth.uid()));
