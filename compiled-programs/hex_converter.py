import sys


def convert_hex_to_big_endian_format(hex_data):
    lines = hex_data.strip().split('\n')
    formatted_output = []

    for line in lines:
        # Extract the machine code part
        parts = line.split("\t")
        if len(parts) >= 2:
            hex_code = parts[1].strip()
            # Split the hex code into byte-sized chunks
            bytes_ordered = [hex_code[i:i+2]
                             for i in range(0, len(hex_code), 2)]
            formatted_output.extend(bytes_ordered)

    return formatted_output


def main():
    hex_data = sys.stdin.read()
    structured_format = convert_hex_to_big_endian_format(hex_data)
    for byte in structured_format:
        print(byte)


if __name__ == "__main__":
    main()
