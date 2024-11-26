import random
from datetime import datetime


def generate_file():
    # Generate a random number of lines
    num_lines = random.randint(1, 100)

    # Create a unique file name
    now = datetime.now()
    timestamp = now.strftime("%Y%m%d_%H%M%S_%f")
    file_name = f"{timestamp}.txt"

    # Write the random number of lines to the file
    with open(file_name, 'w') as file:
        for i in range(num_lines):
            file.write(f"This is line {i} of text.\n")

    print(f"Generated file: {file_name} with {num_lines} lines")


if __name__ == "__main__":
    generate_file()