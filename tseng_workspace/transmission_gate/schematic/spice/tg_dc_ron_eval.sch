v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
T {14 Transmission-Gate} 20 -470 0 0 0.8 0.8 {layer=8}
T {rail-to-rail switch} 20 -410 0 0 0.4 0.4 {}
T {pMOS switch} 500 -350 0 0 0.4 0.4 {layer=11}
T {nMOS switch} 480 120 0 0 0.4 0.4 {layer=11}
N 50 -120 50 -100 {
lab=GND}
N 50 -200 50 -180 {
lab=VDD}
N 550 -20 550 40 {
lab=GND}
N 550 80 550 100 {
lab=von_nmos_sw}
N 490 40 520 40 {
lab=#net1}
N 410 40 430 40 {
lab=vin}
N 790 -240 790 -220 {
lab=vin}
N 790 -160 790 -140 {
lab=GND}
N 790 30 790 50 {
lab=von_pmos_sw}
N 790 110 790 130 {
lab=GND}
N 1030 30 1030 50 {
lab=von_nmos_sw}
N 1030 110 1030 130 {
lab=GND}
N 550 -240 550 -190 {
lab=VDD}
N 510 -240 520 -240 {
lab=#net2}
N 490 -150 510 -150 {
lab=#net2}
N 580 -240 590 -240 {
lab=v2p}
N 590 -150 610 -150 {
lab=v2p}
N 550 -300 550 -280 {
lab=von_pmos_sw}
N 410 -150 430 -150 {
lab=vin}
N 510 -240 510 -150 {
lab=#net2}
N 590 -240 590 -150 {
lab=v2p}
N 140 -110 140 -90 {
lab=GND}
N 140 -190 140 -170 {
lab=v2p}
N 220 -110 220 -90 {
lab=GND}
N 220 -190 220 -170 {
lab=v2n}
N 670 20 670 40 {
lab=v2n}
N 580 40 670 40 {
lab=v2n}
C {sky130_fd_pr/corner.sym} -140 -420 0 0 {name=CORNER only_toplevel=true corner=tt}
C {devices/code_shown.sym} 10 40 0 0 {name=spice only_toplevel=false value=".option savecurrent
.control
save all

* DC analysis
dc vin 0.15 1.53 0.1
*dc vin 0.975 1.025 0.01
*plot i(Vitg)
*plot ylog i(Vitg)
*plot ylog 1.8/i(Vitg)
let vds_pmos_sw=v(v2p)-v(vin)
let ron_pmos_sw=vds_pmos_sw/abs(i(vi_pmos_sw))
let vds_nmos_sw=v(vin)-v(v2n)
let ron_nmos_sw=vds_nmos_sw/i(vi_nmos_sw)
*plot v(v2p) v(v2n)
*plot vds_pmos_sw vds_nmos_sw
*plot abs(i(vi_pmos_sw)) i(vi_nmos_sw)
plot ylog ron_pmos_sw ron_nmos_sw
.endc"}
C {devices/code_shown.sym} -190 40 0 0 {name=param only_toplevel=false value=".param L_n=0.15
.param W_n=15
.param L_p=0.15
.param W_p=60
.param Cload=100f"}
C {devices/vsource.sym} 50 -150 0 0 {name=Vdd value=1.8 savecurrent=false}
C {devices/gnd.sym} 50 -100 0 0 {name=l3 lab=GND}
C {devices/vdd.sym} 50 -200 0 0 {name=l4 lab=VDD}
C {sky130_fd_pr/nfet_01v8.sym} 550 60 3 0 {name=M2
L=L_n
W=W_n
nf=1 mult=1
model=nfet_01v8
spiceprefix=X
}
C {devices/gnd.sym} 550 -20 2 0 {name=l11 lab=GND}
C {devices/lab_pin.sym} 550 100 0 1 {name=p13 sig_type=std_logic lab=von_nmos_sw}
C {devices/ammeter.sym} 460 40 3 0 {name=vi_nmos_sw savecurrent=true}
C {devices/vsource.sym} 790 -190 0 0 {name=Vin value=0 savecurrent=false}
C {devices/gnd.sym} 790 -140 0 0 {name=Vin_pmos_only2 lab=GND}
C {devices/lab_pin.sym} 790 -240 3 1 {name=p17 sig_type=std_logic lab=vin}
C {devices/vsource.sym} 790 80 0 0 {name=Von_pmos_sw3 value=0 savecurrent=false}
C {devices/gnd.sym} 790 130 0 0 {name=Vin_pmos_only4 lab=GND}
C {devices/lab_pin.sym} 790 30 3 1 {name=p19 sig_type=std_logic lab=von_pmos_sw}
C {devices/vsource.sym} 1030 80 0 0 {name=Von_nmos_sw value=1.8 savecurrent=false}
C {devices/gnd.sym} 1030 130 0 0 {name=Vin_pmos_only5 lab=GND}
C {devices/lab_pin.sym} 1030 30 3 1 {name=p20 sig_type=std_logic lab=von_nmos_sw}
C {devices/lab_pin.sym} 410 -150 2 1 {name=p11 sig_type=std_logic lab=vin}
C {sky130_fd_pr/pfet_01v8.sym} 550 -260 3 1 {name=M3
L=L_p
W=W_p
nf=1 mult=1
model=pfet_01v8
spiceprefix=X
}
C {devices/vdd.sym} 550 -190 2 0 {name=l6 lab=VDD}
C {devices/lab_pin.sym} 550 -300 0 1 {name=p12 sig_type=std_logic lab=von_pmos_sw}
C {devices/ammeter.sym} 460 -150 3 0 {name=vi_pmos_sw savecurrent=true}
C {devices/lab_pin.sym} 610 -150 0 1 {name=p1 sig_type=std_logic lab=v2p}
C {devices/capa.sym} 140 -140 0 0 {name=CLp
m=1
value=Cload
footprint=1206
device="ceramic capacitor"}
C {devices/gnd.sym} 140 -90 0 0 {name=l10 lab=GND}
C {devices/lab_pin.sym} 140 -190 3 1 {name=p6 sig_type=std_logic lab=v2p}
C {devices/lab_pin.sym} 410 40 2 1 {name=p4 sig_type=std_logic lab=vin}
C {devices/capa.sym} 220 -140 0 0 {name=CLn
m=1
value=Cload
footprint=1206
device="ceramic capacitor"}
C {devices/gnd.sym} 220 -90 0 0 {name=l1 lab=GND}
C {devices/lab_pin.sym} 220 -190 3 1 {name=p2 sig_type=std_logic lab=v2n}
C {devices/lab_pin.sym} 670 20 3 1 {name=p3 sig_type=std_logic lab=v2n}
C {code_shown.sym} 20 460 0 0 {name=measure1
only_toplevel=true
format="tcleval( @value )"
value="
*.measure dc vtp find v(v2p) when v(vin)=0.02
*.measure dc vtn find v(v2n) when v(vin)=1.8
"}
