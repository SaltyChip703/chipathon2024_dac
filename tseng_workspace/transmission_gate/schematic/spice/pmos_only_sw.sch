v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N -380 -300 -310 -300 {
lab=din}
N -250 -300 -160 -300 {
lab=dout}
N -160 -230 -80 -230 {
lab=dout}
N -480 -230 -380 -230 {
lab=din}
N -280 -390 -280 -340 {
lab=sel_neg}
N -610 -190 -610 -160 {
lab=tg_in}
N -460 -230 -460 -190 {
lab=din}
N -610 -100 -610 -50 {
lab=GND}
N 110 -130 110 -95 {
lab=GND}
N 110 -250 110 -185 {
lab=VDD}
N -280 -300 -280 -230 {
lab=VDD}
N -280 -230 -190 -230 {
lab=VDD}
N -190 -350 -190 -230 {
lab=VDD}
N -190 -350 -100 -350 {
lab=VDD}
N -100 -360 -100 -350 {
lab=VDD}
N 235 -135 235 -95 {
lab=GND}
N 235 -265 235 -195 {
lab=sel_neg}
N -160 -300 -160 -230 {
lab=dout}
N -380 -300 -380 -230 {
lab=din}
N -490 -190 -460 -190 {
lab=din}
N -610 -190 -550 -190 {
lab=tg_in}
C {sky130_fd_pr/pfet_01v8.sym} -280 -320 3 1 {name=M1
W=1
L=0.15
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {iopin.sym} -480 -230 2 0 {name=p1 lab=din}
C {iopin.sym} -80 -230 0 0 {name=p2 lab=dout}
C {iopin.sym} -280 -390 0 0 {name=p4 lab=sel_neg}
C {vdd.sym} -100 -360 0 0 {name=l1 lab=VDD}
C {gnd.sym} -610 -50 0 0 {name=l3 lab=GND}
C {gnd.sym} 110 -95 0 0 {name=l4 lab=GND}
C {vdd.sym} 110 -250 0 0 {name=l5 lab=VDD}
C {vsource.sym} 110 -160 0 0 {name=V2 value=1.8 savecurrent=false}
C {code_shown.sym} -735 15 0 0 {name="MODELS"
only_toplevel=true
format="tcleval( @value )"
value="
.lib /foss/pdks/sky130A/libs.tech/ngspice/sky130.lib.spice tt
"}
C {vsource.sym} 235 -165 0 0 {name=V4 value=0 savecurrent=false}
C {gnd.sym} 235 -100 0 0 {name=l7 lab=GND
value=0}
C {lab_wire.sym} 235 -260 0 0 {name=p6 sig_type=std_logic lab=sel_neg
value=0}
C {vsource.sym} -610 -130 0 0 {name=V1 value="DC 0 PULSE(0 1.8 0ns 2ns 2ns 10ns 20ns 2)" savecurrent=false}
C {simulator_commands_shown.sym} -750 160 0 0 {name=COMMANDS1
simulator=ngspice
only_toplevel=false 
value="
.control
save all
tran 0.1ns 50ns
write ~/pmos_only_sw.raw
wrdata ~/pmos_only_sw.txt v(din) v(dout) v(sel) v(VDD)
run
let v_temp = v(tg_in)-v(din)
let id = v_temp/12.2
let vds = v(dout)-v(din)
let ron = vds/id
plot ron
*plot v(din)
*plot v(dout)
.endc
"}
C {sky130_fd_pr/res_generic_l1.sym} -520 -190 1 0 {name=R1
W=1
L=1
model=res_generic_l1
mult=1}
C {lab_generic.sym} -610 -190 0 0 {name=l2 lab=tg_in}
