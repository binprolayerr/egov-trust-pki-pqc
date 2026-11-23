# Sổ tay vận hành lab PKI Tuần 1

## Chế độ lab được hỗ trợ

Chỉ kiểm thử cục bộ trên một máy đơn lẻ. Các script sử dụng các lệnh CA, OCSP và TSA tích hợp sẵn của OpenSSL. RA được mô phỏng thông qua một bước phê duyệt cục bộ có chủ đích trước khi CA cấp phát chứng chỉ; đây không phải là một dịch vụ RA thực tế (production) độc lập.

## Xây dựng (Build)

~~~bash
./scripts/00-check-prereqs.sh
./scripts/01-build-pki-lab.sh
~~~

Script xây dựng sẽ tạo thư mục `build/` chứa cơ sở dữ liệu CA, các khóa bí mật, chứng chỉ, một chữ ký CMS và truy vấn/phản hồi dấu thời gian. Dữ liệu được sinh ra sẽ bị Git bỏ qua (ignore).

## Kiểm thử 

~~~bash
./scripts/02-test-pki-lab.sh
~~~

Các kiểm tra kỳ vọng: xác thực chuỗi chứng chỉ thành công; phản hồi OCSP được xác minh và trả về trạng thái `good`; chữ ký CMS được xác minh; phản hồi dấu thời gian được xác minh. Nếu có bất kỳ kiểm tra nào thất bại, lệnh sẽ thoát với mã khác 0.

## Smoke test SoftHSM2 / PKCS#11 tùy chọn

Cài đặt SoftHSM2 và OpenSC bằng trình quản lý gói của hệ điều hành của bạn. Sau đó chạy:

~~~bash
./scripts/03-softhsm-smoke.sh
~~~

Script này khởi tạo một token dùng một lần và nhập vào một khóa RSA **chỉ dùng cho thử nghiệm** nếu các công cụ đã cài đặt hỗ trợ các tùy chọn dòng lệnh tương ứng. Đây chỉ là bài kiểm tra nhanh về khả năng vận hành, không phải ký từ xa hay bằng chứng về bảo vệ phần cứng. SoftHSM hoạt động dựa trên nền tảng phần mềm.

## Khắc phục sự cố

- `Unknown option -addext`: hãy sử dụng phiên bản OpenSSL mới (khuyên dùng 3.x); nên cập nhật OpenSSL thay vì âm thầm làm giảm mức bảo mật của hồ sơ chứng chỉ (certificate profile).
- Xác minh mã thông báo (token) TSA thất bại: đảm bảo chứng chỉ TSA có trường mở rộng EKU `timeStamping` được đánh dấu là thiết yếu (critical) và phản hồi được xác minh dựa trên CA thử nghiệm.
- OCSP báo `unknown`: đảm bảo chứng chỉ được cấp bởi chính CA này và tệp `index.txt` có tồn tại.
- Cổng 8888 đang bận: dừng dịch vụ cục bộ khác đang chiếm cổng hoặc thay đổi biến `OCSP_PORT` trước khi chạy xây dựng và kiểm thử.
- Khác biệt dòng lệnh OpenSSL 4.1/PQC: các bài kiểm thử cổ điển của Tuần 1 độc lập với việc hỗ trợ ML-DSA; hãy ghi nhận riêng khả năng hỗ trợ thuật toán/provider cụ thể.