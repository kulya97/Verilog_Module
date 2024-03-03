
//default binary encoding, rx_idle = 0, rx_start_bit = 1, ...
typedef enum logic [2 : 0] {
                            rx_idle, 
                            rx_start_bit, 
                            rx_data_bit, 
                            rx_stop_bit, 
                            rx_cu
                           } state_t;
//explicit binary encoding
typedef enum logic [2 : 0] {
                            rx_idle      = 0, 
                            rx_start_bit = 1, 
                            rx_data_bit  = 2, 
                            rx_stop_bit  = 3, 
                            rx_cu        = 4
                           } state_t;
//one-hot encoding
typedef enum logic [4 : 0] {
                            rx_idle      = 5'b00001, 
                            rx_start_bit = 5'b00010, 
                            rx_data_bit  = 5'b00100, 
                            rx_stop_bit  = 5'b01000, 
                            rx_cu        = 5'b10000
                           } state_t;
//Gray code encoding
typedef enum logic [2 : 0] {
                            rx_idle      = 3'b000, 
                            rx_start_bit = 3'b001, 
                            rx_data_bit  = 3'b011, 
                            rx_stop_bit  = 3'b010, 
                            rx_cu        = 3'b110
                           } state_t;
//Johnson count encoding
typedef enum logic [2 : 0] {
                            rx_idle      = 3'b000, 
                            rx_start_bit = 3'b100, 
                            rx_data_bit  = 3'b110, 
                            rx_stop_bit  = 3'b111, 
                            rx_cu        = 3'b011
                           } state_t;
