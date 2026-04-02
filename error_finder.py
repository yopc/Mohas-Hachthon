
import subprocess
import re
import os


def run_flutter_analyze(project_path):

    flutter_path = r"C:\Users\new\Downloads\flutter\bin\flutter.bat"

    result = subprocess.run(
        [flutter_path, "analyze"],
        cwd=project_path,
        capture_output=True,
        text=True
    )

    return result.stdout + result.stderr


# def extract_errors(output):

#     file_errors = {}

#     pattern = re.compile(r'(lib[\\/][^:]+\.dart):(\d+):(\d+)')

#     for line in output.splitlines():

#         match = pattern.search(line)

#         if match:

#             file_path = match.group(1)
#             line_no = match.group(2)
#             col_no = match.group(3)

#             error_message = line.strip()

#             if file_path not in file_errors:
#                 file_errors[file_path] = []

#             file_errors[file_path].append(
#                 f"Line {line_no}, Column {col_no}: {error_message}"
#             )

#     return file_error


def extract_errors(output):

    file_errors = {}

    pattern = re.compile(r'(lib[\\/][^:]+\.dart):(\d+):(\d+)')

    for line in output.splitlines():

        match = pattern.search(line)

        if match:

            file_path = match.group(1)
            line_no = match.group(2)
            col_no = match.group(3)

            error_message = line.strip()

            if file_path not in file_errors:
                file_errors[file_path] = []

            file_errors[file_path].append(
                f"Line {line_no}, Column {col_no}: {error_message}"
            )

    return file_errors


def generate_report(project_path):

    print("Running flutter analyze...")

    analyze_output = run_flutter_analyze(project_path)

    file_errors = extract_errors(analyze_output)

    if not file_errors:
        print("No compile errors detected.")
        return

    output_file = os.path.join(project_path, "flutter_compile_errors.txt")

    with open(output_file, "w", encoding="utf-8") as report:

        for file_path, errors in file_errors.items():

            report.write(f"\n============ {file_path} ============\n\n")

            full_path = os.path.join(project_path, file_path)

            try:
                with open(full_path, "r", encoding="utf-8") as f:
                    report.write(f.read())
            except Exception as e:
                report.write(f"Unable to read file: {e}\n")

            report.write("\n\n[======== ERRORS ========]\n")

            for err in errors:
                report.write(err + "\n")

    print("Report generated:", output_file)

if __name__ == "__main__":

    project_path = input("Enter Flutter project path: ").strip()

    if not os.path.isdir(project_path):
        print("Invalid project path.")
    else:
        generate_report(project_path)