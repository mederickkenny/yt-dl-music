# Complete Installation Guide for keyfinder-cli on Ubuntu

## Step 1: Install Build Dependencies

``` bash
sudo apt update
sudo apt install -y build-essential cmake git ffmpeg \
    libavcodec-dev libavformat-dev libavutil-dev \
    libswresample-dev libfftw3-dev
```

## Step 2: Build and Install libkeyfinder
keyfinder-cli depends on libkeyfinder, which you need to build from source first:

``` bash
# Clone the libkeyfinder repository
git clone https://github.com/mixxxdj/libkeyfinder.git
cd libkeyfinder

# Build libkeyfinder
cmake -DCMAKE_INSTALL_PREFIX=/usr/local -S . -B build
cmake --build build --parallel $(nproc)
sudo cmake --install build

# Return to parent directory
cd ..
```

## Step 3: Build and Install keyfinder-cli
Now build the CLI tool itself:

``` bash
# Clone the keyfinder-cli repository
git clone https://github.com/evanpurkhiser/keyfinder-cli.git
cd keyfinder-cli

# Build keyfinder-cli
cmake -DCMAKE_INSTALL_PREFIX=/usr/local -S . -B build
cmake --build build
sudo cmake --install build
```

## Step 4: Configure Library Path (Important!)
This step is often forgotten but critical:

``` bash
# Add library path to your shell profile
echo 'export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH' >> ~/.bashrc
source ~/.bashrc

# Update the shared library cache
sudo ldconfig
```

## Step 5: Verify Installation
Test that everything works:
``` bash
keyfinder-cli --version

# Or test with an audio file
keyfinder-cli your_audio.mp3
```

# Troubleshooting
If you get `keyfinder/keyfinder.h: No such file or directory`:

Make sure you installed libkeyfinder to `/usr/local`
Run `sudo ldconfig` again
Check that `/usr/local/lib` contains libkeyfinder files

## If you get library loading errors:

Verify your LD_LIBRARY_PATH includes `/usr/local/lib`
Run `source ~/.bashrc` or restart your terminal

That's the full process! The key thing is building libkeyfinder first, then keyfinder-cli, and making sure the library paths are properly configured.