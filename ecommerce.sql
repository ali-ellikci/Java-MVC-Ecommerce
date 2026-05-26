
-- 1) KULLANICILAR
CREATE TABLE IF NOT EXISTS users (
    id          SERIAL PRIMARY KEY,
    full_name   VARCHAR(150)        NOT NULL,
    email       VARCHAR(150)        NOT NULL UNIQUE,
    password    VARCHAR(255)        NOT NULL,
    phone       VARCHAR(20),
    address     TEXT,
    role        VARCHAR(20)         NOT NULL DEFAULT 'customer',
    created_at  TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2) KATEGORİLER
CREATE TABLE IF NOT EXISTS categories (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(100)        NOT NULL,
    description TEXT,
    is_active   BOOLEAN             NOT NULL DEFAULT TRUE
);

-- 3) ÜRÜNLER
CREATE TABLE IF NOT EXISTS products (
    id          SERIAL PRIMARY KEY,
    category_id INTEGER             NOT NULL REFERENCES categories(id),
    name        VARCHAR(200)        NOT NULL,
    description TEXT,
    price       NUMERIC(10,2)       NOT NULL CHECK (price > 0),
    stock       INTEGER             NOT NULL DEFAULT 0 CHECK (stock >= 0),
    image_url   VARCHAR(500),
    is_active   BOOLEAN             NOT NULL DEFAULT TRUE,
    created_at  TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 4) SİPARİŞLER
CREATE TABLE IF NOT EXISTS orders (
    id              SERIAL PRIMARY KEY,
    user_id         INTEGER         NOT NULL REFERENCES users(id),
    order_date      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_amount    NUMERIC(10,2)   NOT NULL,
    status          VARCHAR(50)     NOT NULL DEFAULT 'Beklemede'
);

-- 5) SİPARİŞ KALEMLERİ
CREATE TABLE IF NOT EXISTS order_items (
    id          SERIAL PRIMARY KEY,
    order_id    INTEGER             NOT NULL REFERENCES orders(id),
    product_id  INTEGER             NOT NULL REFERENCES products(id),
    quantity    INTEGER             NOT NULL CHECK (quantity > 0),
    unit_price  NUMERIC(10,2)       NOT NULL,
    subtotal    NUMERIC(10,2)       NOT NULL
);


-- Admin kullanıcı (şifre: admin123 )
INSERT INTO users (full_name, email, password, phone, address, role) VALUES
('Admin Kullanıcı', 'admin@admin.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '05001234567', 'İstanbul, Türkiye', 'admin')
ON CONFLICT (email) DO NOTHING;

-- Test müşteri (şifre: test123 → BCrypt hash)
INSERT INTO users (full_name, email, password, phone, address, role) VALUES
('Test Kullanıcı', 'test@test.com', '$2a$10$8K1p/a0dR1xqM8K3Qe6MKuQwZ5J7oXRtGvN2bsP4cL6fH9Yd3mIwe', '05559876543', 'Ankara, Türkiye', 'customer')
ON CONFLICT (email) DO NOTHING;

-- Kategoriler
INSERT INTO categories (name, description, is_active) VALUES
('Telefon',    'Akıllı telefonlar ve aksesuar',            TRUE),
('Bilgisayar', 'Laptop, masaüstü ve bileşenler',           TRUE),
('Aksesuar',   'Kılıf, kulaklık, şarj cihazı ve daha fazlası', TRUE),
('Kitap',      'Roman, ders kitabı ve dergiler',            TRUE),
('Giyim',      'Erkek, kadın ve çocuk kıyafetleri',         TRUE);


INSERT INTO products (category_id, name, description, price, stock, image_url, is_active) VALUES
-- Telefonlar
(1, 'Samsung Galaxy S24',
 'Samsung''ın amiral gemisi telefonu. 6.2 inç Dynamic AMOLED ekran, Snapdragon 8 Gen 3 işlemci, 50MP üçlü kamera.',
 32999.99, 15,
 'https://images.unsplash.com/photo-1610945415295-d9bbf067e59c?w=400&h=400&fit=crop', TRUE),

(1, 'iPhone 15 Pro',
 'Apple''ın en güçlü iPhone modeli. A17 Pro çip, titanyum çerçeve, 48MP ana kamera sistemi.',
 54999.99, 8,
 'https://images.unsplash.com/photo-1678911820864-e5e7bd43c6a0?w=400&h=400&fit=crop', TRUE),

(1, 'Xiaomi 14',
 'Leica kamera ortaklığıyla üretilen premium Xiaomi. 6.36 inç AMOLED, Snapdragon 8 Gen 3.',
 24999.99, 20,
 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400&h=400&fit=crop', TRUE),

-- Bilgisayarlar
(2, 'MacBook Air M2',
 'Apple M2 çipli ultra ince laptop. 13.6 inç Liquid Retina ekran, 18 saate kadar pil ömrü.',
 44999.99, 5,
 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400&h=400&fit=crop', TRUE),

(2, 'Lenovo ThinkPad X1 Carbon',
 'İş dünyasının tercihi ultra ince laptop. 14 inç IPS ekran, Intel Core i7, 16GB RAM.',
 38999.99, 7,
 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400&h=400&fit=crop', TRUE),

(2, 'ASUS ROG Strix G16',
 'Oyun severler için güçlü laptop. NVIDIA RTX 4070, Intel i9, 165Hz QHD ekran.',
 49999.99, 3,
 'https://images.unsplash.com/photo-1593642632559-0c6d3fc62b89?w=400&h=400&fit=crop', TRUE),

-- Aksesuarlar
(3, 'Sony WH-1000XM5 Kulaklık',
 'Sektörün en iyi aktif gürültü engelleme özelliğine sahip kablosuz kulaklık.',
 9999.99, 25,
 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&h=400&fit=crop', TRUE),

(3, 'Apple AirPods Pro 2',
 'Aktif gürültü engelleme ve Şeffaflık modu. MagSafe şarj destekli.',
 7499.99, 30,
 'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?w=400&h=400&fit=crop', TRUE),

(3, 'Anker 65W Şarj Adaptörü',
 'USB-C ve USB-A çıkışlı hızlı şarj adaptörü. MacBook, iPad, iPhone uyumlu.',
 899.99, 50,
 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&h=400&fit=crop', TRUE),

-- Kitaplar
(4, 'Clean Code - Robert C. Martin',
 'Yazılım geliştirme dünyasının klasiği. Temiz, okunabilir ve bakımı kolay kod yazma sanatı.',
 299.99, 40,
 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&h=400&fit=crop', TRUE),

(4, 'Dune - Frank Herbert',
 'Bilim kurgunun başyapıtı. Arrakis gezegeninde geçen destansı bir hikaye.',
 189.99, 35,
 'https://images.unsplash.com/photo-1535398089889-dd807df1dfaa?w=400&h=400&fit=crop', TRUE),

-- Giyim
(5, 'Nike Air Max 270',
 'Maksimum konfor için büyük Air birimi. Günlük kullanım için ideal spor ayakkabı.',
 3299.99, 12,
 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&h=400&fit=crop', TRUE),

(5, 'Levi''s 501 Original Jeans',
 'Efsanevi Levi''s 501. Düz kesim, kaliteli denim kumaş. Her dolaba uyum sağlar.',
 1799.99, 18,
 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=400&h=400&fit=crop', TRUE),

(5, 'The North Face Fleece Ceket',
 'Polartec 200 serisi polar. Hafif, sıcak ve hava geçirgen. Outdoor aktiviteler için ideal.',
 2499.99, 0,
 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=400&h=400&fit=crop', TRUE);
