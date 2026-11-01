

CREATE DATABASE db_rs_sejahtera;

-- =========================================
-- 1. TABEL POLIKLINIK
-- =========================================

CREATE TABLE poliklinik (
    id_poli SERIAL PRIMARY KEY,
    nama_poli VARCHAR(50) NOT NULL UNIQUE,
    gedung VARCHAR(50) NOT NULL
);


-- =========================================
-- 2. TABEL PASIEN
-- =========================================

CREATE TABLE pasien (
    id_pasien SERIAL PRIMARY KEY,
    nik VARCHAR(16) NOT NULL UNIQUE,
    nama_pasien VARCHAR(150) NOT NULL,
    jenis_kelamin CHAR(1) CHECK (jenis_kelamin IN ('L', 'P'))
);


-- =========================================
-- 3. TABEL DOKTOR
-- =========================================

CREATE TABLE doktor (
    id_dokter SERIAL PRIMARY KEY,
    nama_dokter VARCHAR(150) NOT NULL,
    no_izin_praktek VARCHAR(30) UNIQUE,
    pengalaman_tahun INTEGER DEFAULT 0 CHECK (pengalaman_tahun >= 0),
    id_poli INTEGER,
    
    CONSTRAINT fk_doktor_poli
        FOREIGN KEY (id_poli)
        REFERENCES poliklinik(id_poli)
);


-- =========================================
-- 4. TABEL REKAM MEDIS
-- =========================================

CREATE TABLE rekam_medis (
    id_rm SERIAL PRIMARY KEY,
    keluhan TEXT NOT NULL,
    biaya_pemeriksaan NUMERIC(15,2) DEFAULT 150000,
    id_pasien INTEGER,
    id_dokter INTEGER,

    CONSTRAINT fk_rm_pasien
        FOREIGN KEY (id_pasien)
        REFERENCES pasien(id_pasien),

    CONSTRAINT fk_rm_dokter
        FOREIGN KEY (id_dokter)
        REFERENCES doktor(id_dokter)
);


-- =========================================
-- 5. TABEL RESEP OBAT
-- =========================================

CREATE TABLE resep_obat (
    id_resep SERIAL PRIMARY KEY,
    nama_obat VARCHAR(100) NOT NULL,
    jumlah INTEGER CHECK (jumlah > 0),
    id_rm INTEGER,

    CONSTRAINT fk_resep_rm
        FOREIGN KEY (id_rm)
        REFERENCES rekam_medis(id_rm)
);