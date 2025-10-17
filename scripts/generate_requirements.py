import subprocess
from pathlib import Path


def main():
    # Use the venv's pip to list installed packages
    venv_pip = Path('.venv/bin/pip')
    if not venv_pip.exists():
        print('Error: .venv pip not found. Activate or create the .venv environment first.')
        return

    out = subprocess.check_output([str(venv_pip), 'freeze'], text=True)
    req_file = Path('requirements.txt')
    req_file.write_text(out)
    print(f'Wrote {req_file} ({len(out.splitlines())} packages)')


if __name__ == '__main__':
    main()
