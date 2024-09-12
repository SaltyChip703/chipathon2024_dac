v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N -140 10 -70 10 {
lab=din}
N 80 -80 160 -80 {
lab=dout}
N -240 -80 -140 -80 {
lab=din}
N -40 50 -40 90 {
lab=sel}
N 140 -20 140 30 {
lab=GND}
N -40 -20 -40 10 {
lab=GND}
N -220 -80 -220 -40 {
lab=din}
N 350 20 350 55 {
lab=GND}
N 350 -100 350 -35 {
lab=VDD}
N 485 25 485 65 {
lab=GND}
N 485 -105 485 -35 {
lab=sel}
N -40 -20 -10 -20 {
lab=GND}
N -10 -20 140 -20 {
lab=GND}
N 80 -80 80 10 {
lab=dout}
N -140 -80 -140 10 {
lab=din}
N -10 10 80 10 {
lab=dout}
N -255 -40 -220 -40 {
lab=din}
N -540 60 -540 80 {
lab=GND}
N -540 -20 -540 0 {
lab=#net1}
N -360 -40 -310 -40 {
lab=#net1}
N -540 -40 -540 -20 {
lab=#net1}
N -540 -40 -360 -40 {
lab=#net1}
C {iopin.sym} -240 -80 2 0 {name=p1 lab=din}
C {iopin.sym} 160 -80 0 0 {name=p2 lab=dout}
C {iopin.sym} -40 90 0 0 {name=p3 lab=sel}
C {gnd.sym} 140 30 0 0 {name=l2 lab=GND}
C {gnd.sym} 350 55 0 0 {name=l4 lab=GND}
C {vdd.sym} 350 -100 0 0 {name=l5 lab=VDD}
C {vsource.sym} 350 -10 0 0 {name=V2 value=1.8 savecurrent=false}
C {vsource.sym} 485 -5 0 0 {name=V3 value=v_sel savecurrent=false}
C {gnd.sym} 485 60 0 0 {name=l6 lab=GND}
C {lab_wire.sym} 485 -95 0 0 {name=p5 sig_type=std_logic lab=sel}
C {simulator_commands_shown.sym} -515 180 0 0 {name=COMMANDS
simulator=ngspice
only_toplevel=false 
value="
.option savecurrent
.control
save all
save @m.xml.msky130_fd_pr__nfet_01v8[gm]
tran 0.05ns 20ns
write ~/nmos_only_sw.raw
wrdata ~/nmos_only_sw.txt v(din) v(dout) v(sel) v(VDD)
run
*let v_temp = v(tg_in)-v(din)
*let id = v_temp/12.2
*let vds = v(dout)-v(din)
*let ron = vds/id
*plot ron
*plot v(din)
*plot v(dout)
.endc
"}
C {sky130_fd_pr/res_generic_l1.sym} -285 -40 1 0 {name=R1
W=1
L=1
model=res_generic_l1
mult=1}
C {code_shown.sym} 35 270 0 0 {name=param
only_toplevel=true
format="tcleval( @value )"
value="
.param pmos_L=0.15
.param pmos_W=1
.param nmos_L=0.15
.param nmos_W=1
.param v_sel=1.8
"}
C {code_shown.sym} 260 270 0 0 {name=measure1
only_toplevel=true
format="tcleval( @value )"
value="
*measure dc gm find @m.xml.msky130_fd_pr__nfet_01v8[gm] at=v_sel
"}
C {devices/vsource.sym} -540 30 0 0 {name=V1 value="DC 0 PULSE(0 1.8 0ns 2ns 2ns 10ns 20ns 2)" savecurrent=false}
C {devices/gnd.sym} -540 80 0 0 {name=l1 lab=GND}
C {sky130_fd_pr/corner.sym} -700 150 0 0 {name=CORNER only_toplevel=true corner=tt}
C {sky130_fd_pr/nfet_01v8_lvt.sym} -40 30 3 0 {name=M1
L=L
W=W
nf=1 mult=1
model=nfet_01v8_lvt
spiceprefix=X
}
