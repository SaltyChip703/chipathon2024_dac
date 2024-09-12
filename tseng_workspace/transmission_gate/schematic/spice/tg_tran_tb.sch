v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
T {14 Transmission-Gate} 20 -530 0 0 0.8 0.8 {layer=8}
T {TG output v2tg swings rail-to-rail
pMOS switch output v2p cannot reach GND
nMOS switch output v2n cannot reach Vdd} 20 -470 0 0 0.4 0.4 {}
T {transmission-gate} 90 -390 0 0 0.4 0.4 {layer=11}
N -470 -410 -470 -390 {
lab=v1}
N -470 -330 -470 -310 {
lab=GND}
N -370 -220 -370 -200 {
lab=von}
N -370 -140 -370 -120 {
lab=GND}
N -270 -60 -270 -40 {
lab=GND}
N -270 -140 -270 -120 {
lab=#net1}
N -320 -150 -310 -150 {
lab=GND}
N -320 -150 -320 -130 {
lab=GND}
N -370 -130 -320 -130 {
lab=GND}
N -310 -210 -310 -190 {
lab=von}
N -370 -210 -310 -210 {
lab=von}
N -270 -220 -270 -200 {
lab=von_b}
N -550 -330 -550 -310 {
lab=GND}
N -550 -410 -550 -390 {
lab=VDD}
N 180 -180 180 -120 {
lab=GND}
N 180 -290 180 -240 {
lab=VDD}
N 140 -290 150 -290 {
lab=v1}
N 140 -290 140 -120 {
lab=v1}
N 140 -120 150 -120 {
lab=v1}
N 120 -200 140 -200 {
lab=v1}
N 210 -120 220 -120 {
lab=v2tg}
N 220 -290 220 -120 {
lab=v2tg}
N 210 -290 220 -290 {
lab=v2tg}
N 220 -200 240 -200 {
lab=v2tg}
N 180 -350 180 -330 {
lab=von_b}
N 180 -80 180 -60 {
lab=von}
N -140 -120 -140 -100 {
lab=GND}
N -140 -200 -140 -180 {
lab=v2tg}
C {sky130_fd_pr/corner.sym} -140 -420 0 0 {name=CORNER only_toplevel=true corner=tt}
C {devices/code_shown.sym} 20 40 0 0 {name=spice only_toplevel=false value=".option savecurrent
.control
save all

* Tran analysis
* To initalise the values for the transient analysis
ic v(v2tg)=0 v(v2p)=0 v(v2n)=0
tran 0.01u 8u
*plot v2tg v1 von 
*plot v2p v1 von_b
*plot v2n v1 von
let tg_potential=abs(v(v1)-v(v2tg))
let tg_ron=tg_potential/i(v1)
*plot tg_ron
.endc"}
C {sky130_fd_pr/nfet_01v8.sym} 180 -100 3 0 {name=M1
L=L_n
W=W_n
nf=1 mult=1
model=nfet_01v8
spiceprefix=X
}
C {devices/vsource.sym} -470 -360 0 0 {name=V1 value="pwl 0 0 1u 0 1.1u 1.8 3u 1.8 3.1u 0" savecurrent=false}
C {devices/lab_pin.sym} -470 -410 3 1 {name=p1 sig_type=std_logic lab=v1}
C {devices/gnd.sym} -370 -120 0 0 {name=l2 lab=GND}
C {devices/vsource.sym} -370 -170 0 1 {name=Von value="pwl 0 1.8 2u 1.8 2.1u 0 4u 0 4.1u 1.8 6u 1.8 6.1u 0" savecurrent=false}
C {devices/lab_pin.sym} -370 -220 3 1 {name=p3 sig_type=std_logic lab=von}
C {devices/lab_pin.sym} 120 -200 2 1 {name=p4 sig_type=std_logic lab=v1}
C {devices/code_shown.sym} -190 40 0 0 {name=param only_toplevel=false value=".param L_n=0.15
.param W_n=15
.param L_p=0.15
.param W_p=60
.param Cload=100f"}
C {devices/vcvs.sym} -270 -170 0 0 {name=E1 value=-1}
C {devices/vsource.sym} -270 -90 0 0 {name=Von_b value=1.8 savecurrent=false}
C {devices/gnd.sym} -270 -40 0 0 {name=l1 lab=GND}
C {devices/lab_pin.sym} -270 -220 3 1 {name=p5 sig_type=std_logic lab=von_b}
C {sky130_fd_pr/pfet_01v8.sym} 180 -310 3 1 {name=M11
L=L_p
W=W_p
nf=1 mult=1
model=pfet_01v8
spiceprefix=X
}
C {devices/vsource.sym} -550 -360 0 0 {name=Vdd value=1.8 savecurrent=false}
C {devices/gnd.sym} -550 -310 0 0 {name=l3 lab=GND}
C {devices/vdd.sym} -550 -410 0 0 {name=l4 lab=VDD}
C {devices/vdd.sym} 180 -240 2 0 {name=l5 lab=VDD}
C {devices/gnd.sym} 180 -180 2 0 {name=l6 lab=GND}
C {devices/lab_pin.sym} 180 -350 0 1 {name=p7 sig_type=std_logic lab=von_b}
C {devices/lab_pin.sym} 180 -60 0 1 {name=p8 sig_type=std_logic lab=von}
C {devices/gnd.sym} -470 -310 0 0 {name=l8 lab=GND}
C {devices/capa.sym} -140 -150 0 0 {name=CLtg
m=1
value="Cload IC=0"
footprint=1206
device="ceramic capacitor"}
C {devices/gnd.sym} -140 -100 0 0 {name=l9 lab=GND}
C {devices/lab_pin.sym} -140 -200 3 1 {name=p2 sig_type=std_logic lab=v2tg}
C {devices/lab_pin.sym} 240 -200 0 1 {name=p10 sig_type=std_logic lab=v2tg}
