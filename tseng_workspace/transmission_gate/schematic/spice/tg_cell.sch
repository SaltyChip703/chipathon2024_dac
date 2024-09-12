v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N -100 -70 -30 -70 {
lab=din}
N -100 -70 -100 90 {
lab=din}
N -100 90 -30 90 {
lab=din}
N 30 -70 120 -70 {
lab=dout}
N 120 -70 120 90 {
lab=dout}
N 30 90 120 90 {
lab=dout}
N 120 -0 200 0 {
lab=dout}
N -200 0 -100 0 {
lab=din}
N 0 130 0 170 {
lab=sel}
N 0 -160 -0 -110 {
lab=sel_neg}
C {sky130_fd_pr/pfet_01v8.sym} 0 -90 1 0 {name=M1
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
C {sky130_fd_pr/nfet_01v8.sym} 0 110 3 0 {name=M2
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
model=nfet_01v8
spiceprefix=X
}
C {iopin.sym} -200 0 2 0 {name=p1 lab=din}
C {iopin.sym} 200 0 0 0 {name=p2 lab=dout}
C {iopin.sym} 0 170 0 0 {name=p3 lab=sel}
C {iopin.sym} 0 -160 0 0 {name=p4 lab=sel_neg}
