# EGOV TRUST PKI PQC 

**Phạm vi:** kiến trúc, mô hình mối đe dọa, ánh xạ tiêu chuẩn, phòng lab PKI thử nghiệm (CA/RA, OCSP, TSA) và danh mục khóa/bí mật.

> Đây là bản thử nghiệm chứng minh khái niệm (PoC) cục bộ phục vụ mục đích giáo dục, chỉ sử dụng các danh tính giả lập và khóa thử nghiệm. Đây không phải là một CA thực tế (production), dịch vụ tin cậy đủ điều kiện hay bằng chứng có giá trị pháp lý.

## Yêu cầu hệ thống

- OpenSSL 3.x trở lên (các script sử dụng các lệnh X.509, CMS, OCSP và dấu thời gian được hỗ trợ rộng rãi).
- Bash, `openssl`, `awk`, `grep`, `sed`, `date`, `mkdir`, `chmod`.
- Tùy chọn: SoftHSM2 + OpenSC (`softhsm2-util`, `pkcs11-tool`) cho bài thực hành PKCS#11.
- Khuyên dùng Linux, macOS hoặc WSL2. Không chạy các shell script trên Windows CMD/PowerShell.

## Bắt đầu nhanh

~~~bash
git clone https://github.com/binprolayerr/egov-trust-pki-pqc
chmod +x scripts/*.sh
./scripts/00-check-prereqs.sh
./scripts/01-build-pki-lab.sh
./scripts/02-test-pki-lab.sh
~~~

Phòng lab sẽ tạo ra CA cục bộ, yêu cầu RA, chứng chỉ người ký, bộ phản hồi OCSP, chứng chỉ TSA, chữ ký CMS và phản hồi dấu thời gian trong thư mục `build/`. Cơ sở dữ liệu CA và các khóa bí mật được thiết kế để lưu trữ cục bộ và có thể xóa bỏ dễ dàng.

Để dọn dẹp toàn bộ dữ liệu đã tạo:

~~~bash
./scripts/99-clean.sh
~~~

## Cấu trúc kho lưu trữ

- `docs/architecture.md` — các tác nhân, thành phần, ranh giới tin cậy, luồng dữ liệu và các bất biến bảo mật.
- `docs/threat-model.md` — tài sản, mối đe dọa, biện pháp giảm thiểu và rủi ro tồn dư.
- `docs/standards-map.md` — các tiêu chuẩn và ranh giới triển khai.
- `docs/key-inventory.md` — danh mục đầu vào bí mật và các cấp độ bảo vệ H0–H3.
- `docs/runbook.md` — hướng dẫn cài đặt, kiểm thử và khắc phục sự cố có thể tái lập.
- `config/openssl/` — cấu hình OpenSSL cho CA, OCSP và TSA.
- `scripts/` — các script xây dựng, kiểm thử và dọn dẹp phòng lab mang tính xác định.
- `tests/` — kết quả kỳ vọng của phòng lab và danh sách kiểm tra nghiệm thu thủ công.
- `evidence/` — dành riêng cho nhật ký kiểm thử và ảnh chụp màn hình đã được làm sạch thông tin nhạy cảm; không commit khóa bí mật.

## Ranh giới bảo mật

Thư mục `build/` được Git bỏ qua (ignore). Thư mục này chứa các khóa bí mật thử nghiệm, trạng thái cơ sở dữ liệu CA và các tạo phẩm được sinh ra. Chỉ commit mã nguồn/cấu hình/tài liệu và các bằng chứng kiểm thử đã được làm sạch dữ liệu nhạy cảm.
