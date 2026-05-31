#!/bin/bash

# ========================================================
# İsim SOYİSİM: Yusuf Mert [SOYADIN]
# Öğrenci Numarası: [ÖĞRENCİ NUMARAN]
# Sertifika 1 (Docker): [Buraya Docker Sertifika Linkini Yapıştır]
# Sertifika 2 (Linux): [Buraya Linux Sertifika Linkini Yapıştır]
# Sertifika 3 (Bash): [Buraya Bash Script Sertifika Linkini Yapıştır]
# ========================================================

# 1. Günlük Dosyasının Başlatılması ve ISO Zaman Damgası
LOG_DOSYAM="report.log"
date +"%Y-%m-%dT%H:%M:%S%z" > "$LOG_DOSYAM"

echo "=== MACBOOK M2 SISTEM DETAYLARI ===" >> "$LOG_DOSYAM"

# 2. Donanım Bilgilerinin Toplanması
system_profiler SPHardwareDataType | grep -E "Processor Name|Total Number of Cores|Memory|Model Identifier" >> "$LOG_DOSYAM"
system_profiler SPStorageDataType | grep -E "Device Name|Volume UUID" >> "$LOG_DOSYAM"
ifconfig | grep -A 3 "en0" >> "$LOG_DOSYAM"

# 3. Kullanıcıdan Parola Girişi Alınması
echo "Sistem raporunu kriptolamak icin tanimlanan parolayi giriniz."
read -s -p "Parola: " PAROLA
echo ""

# Parola Kontrolü
if [ "$PAROLA" != "MYO+202" ]; then
    echo "Hata: Gecersiz parola girildi! Islem sonlandirildi."
    rm -f "$LOG_DOSYAM"
    exit 1
fi

# 4. GPG ile Arka Planda (Batch) AES256 Simetrik Şifreleme
echo "$PAROLA" | gpg --batch --yes --passphrase-fd 0 --cipher-algo AES256 -c "$LOG_DOSYAM"

# 5. Orijinal Şifresiz Log Dosyasının Otomatik Silinmesi
if [ -f "report.log.gpg" ]; then
    rm -f "$LOG_DOSYAM"
    echo "Rapor basariyla AES256 ile sifrelendi: report.log.gpg"
else
    echo "Sifreleme adiminda bir sorun olustu!"
fi
# Son Guncelleme:  1 Haz 2026 Pzt +03 00:04:27
