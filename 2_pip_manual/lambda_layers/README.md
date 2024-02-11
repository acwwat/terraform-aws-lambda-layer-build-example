Follow the instructions below to construct the example Lambda zip file which will be deployed by the Terraform configuration:

1. Ensure that Python 3.11 is installed on your system.
2. In the local directory, create a directory named `python`.
3. Create a file named `requirements.txt` in the `python` directory.
4. Open `requirements.txt` with a text editor. Enter `numpy` on the first line and save the file.
5. Open a command prompt. Change to the `python` directroy and run the following command:
   ```
   pip install --platform=manylinux_2_17_x86_64 --only-binary=:all: -r requirements.txt -t .
   ```
6. With a zip program, create a zip file named `example-lambda-layer.zip` that contains the `python` directory.
7. Copy `example-lambda-layer.zip` to this directory (`lambda_layers`).
