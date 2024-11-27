import json
import os
import subprocess


# Get terraform outputs
def get_terraform_outputs():
    state_path = '../enviroment/dev/terraform.tfstate'
    result = subprocess.run([
        'terraform', 'output', '-json', f'-state={state_path}'
    ],
        capture_output=True,
        text=True)
    return json.loads(result.stdout)


# Create .env file with outputs
def update_env_file(env_vars):
    env_file_path = '../.env'

    if os.path.exists(env_file_path):
        os.remove(env_file_path)

    try:
        with open(env_file_path, 'r') as file:
            lines = file.readlines()
    except FileNotFoundError:
        lines = []

    for key, value in env_vars.items():
        line = f"{key}={value['value']}\n"
        lines.append(line)

    with open(env_file_path, 'w') as file:
        file.writelines(lines)


if __name__ == "__main__":
    outputs = get_terraform_outputs()
    update_env_file(outputs)
