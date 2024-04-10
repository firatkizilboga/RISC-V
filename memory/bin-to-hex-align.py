def binary_to_hex(binary_str):
    # Remove spaces and pad to 32 bits
    binary_str = binary_str.replace(" ", "").replace("\n0000", "")

    # Convert binary to hexadecimal
    hex_str = hex(int(binary_str, 2))[2:].zfill(8)

    return hex_str


def process_file(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    hex_output = [binary_to_hex(line.strip()) for line in lines]
    return hex_output


file_path = input("Enter the path of your binary file: ")
hex_instructions = process_file(file_path)

print("Hexadecimal output:")
for hex_instruction in hex_instructions:
    print(hex_instruction)
