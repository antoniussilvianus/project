-- Anda dihadapkan dengan project dimana memiliki data penjualan dengan informasi sebagai berikut : 
-- Data Barang		: Nama, Kategori, Jumlah Barang, Keterangan 
-- Data Pembeli		: Nama, Nomor Identitas, Jenis Kelamin, Alamat, Nomor HP 
-- Data Penjualan	: Barang, Pembeli, Jumlah Beli, Tanggal Beli, Lokasi Toko 
-- Data Toko		: Nama Toko, Alamat Toko 
-- 1.	Buatkan struktur tabel untuk empat data yang dibutuhkan dengan konsep relasional database yang baik dan benar.  
-- 2.	Bila dihadapkan dengan jumlah data dimana data penjualan berjumlah 50 Juta, bagaimana membuat sebuah skema database yang tepat agar pembagian beban baik itu ketika data diinput/diambil bisa memenuhi SLA < 1 detik. (Misalkan : Zonasi based on lokasi toko dsb) 
-- 1 Struktur Table Relasional
-- tabel barang
CREATE TABLE
    Barang (
        BarangID INT AUTO_INCREMENT PRIMARY KEY,
        Nama VARCHAR(100) NOT NULL,
        Kategori VARCHAR(50),
        Jumlah INT NOT NULL,
        Keterangan TEXT
    ) ENGINE = InnoDB;

-- tabel pembeli
CREATE TABLE
    Pembeli (
        PembeliID INT AUTO_INCREMENT PRIMARY KEY,
        Nama VARCHAR(100) NOT NULL,
        NomorIdentitas VARCHAR(20) NOT NULL,
        JenisKelamin ENUM ('Laki-laki', 'Perempuan') NOT NULL,
        Alamat TEXT,
        NomorHP VARCHAR(20)
    ) ENGINE = InnoDB;

-- tabel penjualan
CREATE TABLE
    Penjualan (
        PenjualanID BIGINT AUTO_INCREMENT PRIMARY KEY,
        BarangID INT NOT NULL,
        PembeliID INT NOT NULL,
        TokoID INT NOT NULL,
        JumlahBeli INT NOT NULL,
        TanggalBeli DATETIME NOT NULL,
        FOREIGN KEY (BarangID) REFERENCES Barang (BarangID),
        FOREIGN KEY (PembeliID) REFERENCES Pembeli (PembeliID),
        FOREIGN KEY (TokoID) REFERENCES Toko (TokoID)
    ) ENGINE = InnoDB
PARTITION BY
    RANGE (YEAR (TanggalBeli)) (
        PARTITION p0
        VALUES
            LESS THAN (2022),
            PARTITION p1
        VALUES
            LESS THAN (2023),
            PARTITION p2
        VALUES
            LESS THAN (2024),
            PARTITION p3
        VALUES
            LESS THAN (2025),
            PARTITION p4
        VALUES
            LESS THAN (MAXVALUE)
    );

-- penggunaan partisi untuk membagi data penjualan berdasarkan tahun
-- penggunaan index untuk mempermudah pencarian
CREATE INDEX idx_Toko_TanggalBeli ON Penjualan (TokoID, TanggalBeli);

CREATE INDEX idx_Barang ON Penjualan (BarangID);

-- contoh query untuk menampilkan data penjualan berdasarkan lokasi toko
SELECT
    *
FROM
    Penjualan
WHERE
    YEAR (TanggalBeli) = 2022
    AND MONTH (TanggalBeli) = 1
    AND DAY (TanggalBeli) = 1
    AND TokoID = 1;

-- contoh query untuk mendapatkan penjualan pada toko tertentu dan rentang tanggal tertentu
SELECT
    BarangID,
    SUM(JumlahBeli) AS TotalBarangTerjual
FROM
    Penjualan
WHERE
    TokoID = 1
    AND TanggalBeli BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY
    BarangID;

--Created By : Antonius Silvianus 
--Created At : 2024-10-25