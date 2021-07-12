# Interfacing a precision scale with a Raspberry Pi or a computer

[![Open in Visual Studio Code](https://open.vscode.dev/badges/open-in-vscode.svg)](https://open.vscode.dev/ARCHIMED-platform/precision_scale-raspberry_pi)

The following code helps you interfacing a Raspberry Pi (or any computer really) with a precision scale and log the measurement values into a file.

## Use the script

### Log in

---

If you're using a regular computer (not a Raspberry), go to the [next step directly](#clone-or-download).

---

If you're using a Raspberry Pi, you'll first have log onto it. If you don't have a screen + keyboard connected to your Raspberry, you can connect using another computer using an RJ45 (ethernet) cable and use SSH. To use SSH, open a terminal (on windows: `Windows key + R`, and then type `powershell` + `Enter`). If you didn't change the default name of the Raspberry,
enter the following command:

```bash
ssh pi@raspberrypi.local
```

The default password is `raspberry`.

### Clone or download

Download this project onto the computer (or Raspberry).

If you're using a Raspberry, are usually using Windows and are not familiar with Linux, you can download the project onto your Windows computer and use [FileZilla](https://filezilla-project.org/) to move the folder from your computer to the Raspberry.

### Change directory

Open a terminal and `cd` into the project you just downloaded. For example if you put it onto the `Documents` folder you'll do:

```bash
cd Documents/precision_scale-raspberry_pi
```

### Change the parameters

Open the file named `parameters.yml` and change the values of the connexion parameters according to the ones given by the manufacturer of the scale, or the one you parameterized onto your scale.

---

#### Note

You can use Julia to know which serial port is used for the connexion. Simply execute this code and copy/paste the results into the `portname` value in `parameters.yml`:

```julia
using Pkg; Pkg.activate(".")
using SerialPorts
list_serialports()
```

---

### Run the script

Run the script into Julia:

```bash
julia monitor_weight.jl
```

If you're running the script onto a Raspberry-Pi, you probably want to use `nohup` so you can reconnect to the process afterward (no hang-up after disconnection). To do so, run the following command instead.

```bash
nohup julia monitor_weight.jl
```

That's it! Julia is now monitoring the data sent by the scale.

---

## Python dependency

If you want to avoid the Python dependency, use the branch named [Using-LibSerialPort.jl-instead-of-SerialPorts.jl](https://github.com/ARCHIMED-platform/Precision_scale-Raspberry_Pi/tree/Using-LibSerialPort.jl-instead-of-SerialPorts.jl) which uses LibSerialPort. This is far better but does not build on my Raspberry Pi (don't know why).
