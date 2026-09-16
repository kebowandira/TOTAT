-- ============================================================
-- TOTAT — Supabase PostgreSQL Migration Schema
-- Converted from Convex schema.ts · Sep 2026
-- GDrive: https://drive.google.com/drive/folders/1u5dWXJF6eDGy4rkBU3WrLAbxx7J7UWNI
-- Deploy: Supabase SQL Editor → paste → run
-- NOT for NL1 direct use — this is for Supabase cloud DB
-- ============================================================


CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


-- USERS
CREATE TABLE public.users (
  id            UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  nama_warung   TEXT,
  limit_hutang  NUMERIC DEFAULT 0,
  qris_url      TEXT,
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);


-- PRODUK
CREATE TABLE public.produk (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id     UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  nama        TEXT NOT NULL,
  harga_beli  NUMERIC NOT NULL DEFAULT 0,
  harga_jual  NUMERIC NOT NULL DEFAULT 0,
  stok        NUMERIC NOT NULL DEFAULT 0,
  satuan      TEXT NOT NULL DEFAULT 'pcs',
  kategori    TEXT,
  supplier_id UUID,
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_produk_user ON public.produk(user_id);


-- PELANGGAN
CREATE TABLE public.pelanggan (
  id           UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id      UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  nama         TEXT NOT NULL,
  no_hp        TEXT,
  total_hutang NUMERIC NOT NULL DEFAULT 0,
  foto_url     TEXT,
  created_at   TIMESTAMPTZ DEFAULT NOW(),
  updated_at   TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_pelanggan_user ON public.pelanggan(user_id);


-- SUPPLIER
CREATE TABLE public.supplier (
  id        UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id   UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  nama      TEXT NOT NULL,
  no_hp     TEXT,
  alamat    TEXT,
  catatan   TEXT,
  tipe      TEXT CHECK (tipe IN ('toko', 'sales keliling')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_supplier_user ON public.supplier(user_id);


ALTER TABLE public.produk
  ADD CONSTRAINT fk_produk_supplier
  FOREIGN KEY (supplier_id) REFERENCES public.supplier(id) ON DELETE SET NULL;


-- PENJUALAN
CREATE TABLE public.penjualan (
  id           UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id      UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  tanggal      DATE NOT NULL,
  total        NUMERIC NOT NULL DEFAULT 0,
  metode_bayar TEXT NOT NULL CHECK (metode_bayar IN ('tunai','hutang','transfer','qris')),
  pelanggan_id UUID REFERENCES public.pelanggan(id) ON DELETE SET NULL,
  catatan      TEXT,
  dibatalkan   BOOLEAN NOT NULL DEFAULT FALSE,
  created_at   TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_penjualan_user_tanggal ON public.penjualan(user_id, tanggal);


-- ITEM PENJUALAN
CREATE TABLE public.item_penjualan (
  id           UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  penjualan_id UUID NOT NULL REFERENCES public.penjualan(id) ON DELETE CASCADE,
  produk_id    UUID REFERENCES public.produk(id) ON DELETE SET NULL,
  nama_produk  TEXT NOT NULL,
  qty          NUMERIC NOT NULL,
  harga_satuan NUMERIC NOT NULL,
  subtotal     NUMERIC NOT NULL,
  harga_beli   NUMERIC
);
CREATE INDEX idx_item_penjualan ON public.item_penjualan(penjualan_id);


-- HUTANG
CREATE TABLE public.hutang (
  id             UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id        UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  pelanggan_id   UUID NOT NULL REFERENCES public.pelanggan(id) ON DELETE CASCADE,
  penjualan_id   UUID REFERENCES public.penjualan(id) ON DELETE SET NULL,
  jumlah         NUMERIC NOT NULL,
  keterangan     TEXT,
  tanggal        DATE NOT NULL,
  janji_bayar    DATE,
  lunas          BOOLEAN NOT NULL DEFAULT FALSE,
  tanggal_lunas  DATE,
  created_at     TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_hutang_user_lunas ON public.hutang(user_id, lunas);


-- KAS AWAL
CREATE TABLE public.kas_awal (
  id        UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id   UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  tanggal   DATE NOT NULL,
  jumlah    NUMERIC NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, tanggal)
);


-- PEMBELIAN STOK
CREATE TABLE public.pembelian_stok (
  id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id         UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  supplier_id     UUID REFERENCES public.supplier(id) ON DELETE SET NULL,
  nama_supplier   TEXT,
  tipe_pembelian  TEXT NOT NULL CHECK (tipe_pembelian IN ('beli_sendiri','sales_keliling')),
  tanggal         DATE NOT NULL,
  total           NUMERIC NOT NULL DEFAULT 0,
  metode_bayar    TEXT NOT NULL CHECK (metode_bayar IN ('tunai','transfer','kredit')),
  jatuh_tempo     DATE,
  lunas           BOOLEAN NOT NULL DEFAULT FALSE,
  catatan         TEXT,
  foto_nota_url   TEXT,
  created_at      TIMESTAMPTZ DEFAULT NOW()
);


-- ITEM PEMBELIAN STOK
CREATE TABLE public.item_pembelian_stok (
  id           UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  pembelian_id UUID NOT NULL REFERENCES public.pembelian_stok(id) ON DELETE CASCADE,
  produk_id    UUID REFERENCES public.produk(id) ON DELETE SET NULL,
  nama_produk  TEXT NOT NULL,
  qty          NUMERIC NOT NULL,
  harga_beli   NUMERIC NOT NULL,
  subtotal     NUMERIC NOT NULL
);


-- PENYESUAIAN STOK
CREATE TABLE public.penyesuaian_stok (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id     UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  produk_id   UUID REFERENCES public.produk(id) ON DELETE SET NULL,
  nama_produk TEXT NOT NULL,
  qty         NUMERIC NOT NULL,
  alasan      TEXT NOT NULL,
  tanggal     DATE NOT NULL,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);


-- LICENSE
CREATE TABLE public.license (
  user_id       UUID PRIMARY KEY REFERENCES public.users(id) ON DELETE CASCADE,
  plan          TEXT NOT NULL DEFAULT 'free',
  license_until DATE,
  activated_at  TIMESTAMPTZ DEFAULT NOW(),
  renewed_at    TIMESTAMPTZ,
  notes         TEXT
);


-- ROW LEVEL SECURITY
ALTER TABLE public.users              ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.produk             ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pelanggan          ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.supplier           ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.penjualan          ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.item_penjualan     ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.hutang             ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kas_awal           ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pembelian_stok     ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.item_pembelian_stok ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.penyesuaian_stok   ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.license            ENABLE ROW LEVEL SECURITY;


CREATE POLICY "users own data" ON public.users FOR ALL USING (auth.uid() = id);
CREATE POLICY "produk own data" ON public.produk FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "pelanggan own data" ON public.pelanggan FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "supplier own data" ON public.supplier FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "penjualan own data" ON public.penjualan FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "hutang own data" ON public.hutang FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "kas_awal own data" ON public.kas_awal FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "pembelian_stok own data" ON public.pembelian_stok FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "penyesuaian own data" ON public.penyesuaian_stok FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "license own data" ON public.license FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "item_penjualan own data" ON public.item_penjualan FOR ALL USING (
  penjualan_id IN (SELECT id FROM public.penjualan WHERE user_id = auth.uid()));
CREATE POLICY "item_pembelian own data" ON public.item_pembelian_stok FOR ALL USING (
  pembelian_id IN (SELECT id FROM public.pembelian_stok WHERE user_id = auth.uid()));