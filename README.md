# 🔎 Recon Automation – Subdomain Enumeration & Live Host Detection

Proyek ini merupakan automasi proses reconnaissance (recon) untuk enumerasi subdomain dan pengecekan host aktif. Script utama bernama `recon-auto.sh`, yang menjalankan proses enumerasi, deduplikasi, logging, hingga pengecekan live hosts menggunakan berbagai tool populer seperti `assetfinder`, `anew`, dan `httpx`.

Output akhir dari script ini berupa:

* Daftar subdomain unik
* Daftar host yang hidup (live)
* Log proses dan error dengan timestamp

---

## 📦 1. Struktur Direktori

```
recon-automation-[firstname]/
│
├── input/
│   └── domains.txt
│
├── output/
│   ├── all-subdomains.txt
│   └── live.txt
│
├── scripts/
│   └── recon-auto.sh
│
├── logs/
│   ├── progress.log
│   └── errors.log
│
└── README.md
```

---

## ⚙️ 2. Cara Setup Environment (Kali Linux)

### STEP 1 — Update sistem

```
sudo apt update && sudo apt upgrade -y
```

### STEP 2 — Install Golang

```
sudo apt install golang -y
```

Verifikasi:

```
go version
```

### STEP 3 — Tambahkan GOPATH/bin ke PATH

```
echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.bashrc
source ~/.bashrc
```

### STEP 4 — Install Tools Recon

#### ✔ Install anew

```
go install -v github.com/tomnomnom/anew@latest
```

#### ✔ Install assetfinder

```
go install -v github.com/tomnomnom/assetfinder@latest
```

#### ✔ Install httpx

```
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
```

### STEP 5 — Verifikasi semua tool siap

```
anew -h
assetfinder -h
httpx -h
```

---

## ▶️ 3. Cara Menjalankan Script

Masuk ke folder scripts:

```
cd scripts
chmod +x recon-auto.sh
./recon-auto.sh
```

Hasil akan muncul di folder:

```
output/all-subdomains.txt
output/live.txt
```

Log proses & error:

```
logs/progress.log
logs/errors.log
```

---

## 📥 4. Contoh Input (input/domains.txt)

```
google.com
yahoo.com
bing.com
github.com
reddit.com
```

---

## 📤 5. Contoh Output

### output/all-subdomains.txt

```
mail.google.com
maps.google.com
drive.google.com
login.yahoo.com
api.github.com
```

### output/live.txt

```
https://mail.google.com
https://github.com
https://maps.google.com
```

---

## 🧠 6. Penjelasan Singkat Setiap Bagian Kode (recon-auto.sh)

### 1. Variabel File Input & Output

```bash
INPUT_FILE="../input/domains.txt"
OUTPUT_SUB="../output/all-subdomains.txt"
OUTPUT_LIVE="../output/live.txt"
```

### 2. Fungsi Timestamp

```bash
timestamp() {
    date "+%Y-%m-%d %H:%M:%S"
}
```

### 3. Validasi File Input

```bash
if [[ ! -f "$INPUT_FILE" ]]; then
    echo "ERROR: input file not found!"
    exit 1
fi
```

### 4. Enumerasi Subdomain

```bash
assetfinder "$domain" 2>> $LOG_ERROR | anew $OUTPUT_SUB
```

### 5. Cek Host Aktif

```bash
cat $OUTPUT_SUB | httpx -silent 2>> $LOG_ERROR | anew $OUTPUT_LIVE
```

### 6. Ringkasan Akhir

```bash
TOTAL_SUB=$(wc -l < $OUTPUT_SUB)
TOTAL_LIVE=$(wc -l < $OUTPUT_LIVE)
```
