# Danh sách kiểm thử Tuần 1

Ghi lại ngày tháng, hệ điều hành (OS), phiên bản OpenSSL và người kiểm thử vào báo cáo dự án.

- [ ] `00-check-prereqs.sh` thoát với mã 0 và ghi lại phiên bản OpenSSL.
- [ ] `01-build-pki-lab.sh` thoát với mã 0 từ trạng thái sạch.
- [ ] Chứng chỉ người ký được xác minh thành công với CA thử nghiệm.
- [ ] Chữ ký phản hồi OCSP được xác minh và trả về trạng thái `good`.
- [ ] Chữ ký tách rời (detached signature) CMS được xác minh thành công với CA thử nghiệm.
- [ ] Phản hồi RFC 3161 được xác minh thành công với chứng chỉ TSA thử nghiệm.
- [ ] Thư mục `build/` được Git bỏ qua (ignore) và không chứa dữ liệu thật.
- [ ] Bài kiểm tra nhanh (smoke test) SoftHSM2 đã đạt hoặc được đánh dấu là không khả dụng kèm theo lý do.
- [ ] Đã rà soát kiến trúc, mô hình mối đe dọa, ánh xạ tiêu chuẩn và danh mục khóa.
- [ ] Không có bí mật thực tế (production), dữ liệu cá nhân thật hoặc khóa bí mật nào được đưa vào vùng chờ (staged).