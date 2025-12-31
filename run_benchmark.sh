#!/bin/bash

# Cấu hình
CONTAINER_NAME="travel_postgres"
DB_USER="myuser"
DB_NAME="travel_db"
RESULTS_DIR="benchmarks"
CONFIGS_DIR="$RESULTS_DIR/configs"
CSV_FILE="$RESULTS_DIR/results.csv"

# Màu sắc cho output đẹp hơn
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Tạo file CSV nếu chưa tồn tại
if [ ! -f "$CSV_FILE" ]; then
    mkdir -p "$RESULTS_DIR"
    mkdir -p "$CONFIGS_DIR"
    echo "Timestamp,TPS,Latency_Avg_ms,Init_Conn_Time_ms,Trans_Processed,Scaling_Factor,Clients,Threads,Duration_s,Config_File" > "$CSV_FILE"
fi

echo -e "${YELLOW}--- Bắt đầu quy trình Benchmark ---${NC}"

# 1. Kiểm tra xem DB đã được init pgbench chưa
echo -e "Kiểm tra dữ liệu pgbench..."
if ! docker exec $CONTAINER_NAME psql -U $DB_USER -d $DB_NAME -c "SELECT count(*) FROM pgbench_accounts;" > /dev/null 2>&1; then
    echo -e "${YELLOW}Dữ liệu chưa tồn tại. Đang khởi tạo (Scale factor 10)...${NC}"
    docker exec $CONTAINER_NAME pgbench -i -s 10 -U $DB_USER -d $DB_NAME
else
    echo -e "${GREEN}Dữ liệu đã sẵn sàng.${NC}"
fi

# 2. Chuẩn bị tên file và timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
CONFIG_FILENAME="config_${TIMESTAMP}.txt"
CONFIG_PATH="$CONFIGS_DIR/$CONFIG_FILENAME"

# 3. Lưu cấu hình hiện tại (Snapshot configuration)
echo -e "Đang lưu cấu hình hiện tại vào ${CONFIG_PATH}..."
docker exec $CONTAINER_NAME psql -U $DB_USER -d $DB_NAME -c "SHOW ALL;" > "$CONFIG_PATH"

# 4. Chạy Benchmark
echo -e "${YELLOW}Đang chạy benchmark (60 giây)... vui lòng đợi.${NC}"
# Chạy pgbench và lưu output vào biến
OUTPUT=$(docker exec $CONTAINER_NAME pgbench -c 10 -j 2 -T 60 -U $DB_USER -d $DB_NAME)

# 5. Parse kết quả
# Extract values using grep and awk
SCALING_FACTOR=$(echo "$OUTPUT" | grep "scaling factor:" | awk '{print $3}')
CLIENTS=$(echo "$OUTPUT" | grep "number of clients:" | awk '{print $4}')
THREADS=$(echo "$OUTPUT" | grep "number of threads:" | awk '{print $4}')
DURATION=$(echo "$OUTPUT" | grep "duration:" | awk '{print $2}')
TRANS_PROCESSED=$(echo "$OUTPUT" | grep "number of transactions actually processed:" | awk '{print $6}')
LATENCY_AVG=$(echo "$OUTPUT" | grep "latency average =" | awk '{print $4}')
INIT_CONN_TIME=$(echo "$OUTPUT" | grep "initial connection time =" | awk '{print $5}')
TPS=$(echo "$OUTPUT" | grep "tps =" | awk '{print $3}')

# 6. Ghi vào CSV
echo "$TIMESTAMP,$TPS,$LATENCY_AVG,$INIT_CONN_TIME,$TRANS_PROCESSED,$SCALING_FACTOR,$CLIENTS,$THREADS,$DURATION,$CONFIG_FILENAME" >> "$CSV_FILE"

echo -e "${GREEN}Hoàn tất!${NC}"
echo -e "TPS: ${GREEN}$TPS${NC}"
echo -e "Latency Avg: ${GREEN}$LATENCY_AVG ms${NC}"
echo -e "Trans Processed: ${GREEN}$TRANS_PROCESSED${NC}"
echo -e "Kết quả đã được lưu vào: $CSV_FILE"
