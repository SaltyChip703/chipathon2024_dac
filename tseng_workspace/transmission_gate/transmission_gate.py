#from glayout.flow.pdk.gf180_mapped import gf180
from glayout.flow.pdk.sky130_mapped import sky130_mapped_pdk as sky130
from glayout.flow.pdk.mappedpdk import MappedPDK
from glayout.flow.pdk.util.comp_utils import evaluate_bbox
from gdsfactory import Component
from gdsfactory.components import rectangle
from glayout.flow.primitives.fet import pmos
from glayout.flow.primitives.fet import nmos
from glayout.flow.routing.straight_route import straight_route
from glayout.flow.routing.c_route import c_route
from glayout.flow.routing.L_route import L_route
from glayout.flow.routing.smart_route import smart_route
from glayout.flow.placement.two_transistor_interdigitized import two_nfet_interdigitized
from glayout.flow.placement.two_transistor_interdigitized import two_pfet_interdigitized
from glayout.flow.pdk.util.comp_utils import prec_ref_center, movey, evaluate_bbox

def transmissionGate_cell(pdk: MappedPDK, width, length):
	# To create the necessary subblocks with particular characteristics
	pfet = pmos(pdk=pdk, with_substrate_tap=False, with_dummy=(False, False), width=width, length=length)
	nfet = nmos(pdk=pdk, with_substrate_tap=False, with_dummy=(False, False), width=width, length=length)
	
	# Add the subblocks to the top-level block and create the I/O ports at the top level
	top_level = Component(name="TG")
	pfet_ref = prec_ref_center(pfet)  # To add it to the top of the component, i.e. top_level
	nfet_ref = prec_ref_center(nfet)  # To add it to the top of the component, i.e. top_level
	top_level.add(pfet_ref)
	top_level.add(nfet_ref)
	top_level.add_ports(pfet_ref.get_ports_list(), prefix="pmos_")
	top_level.add_ports(nfet_ref.get_ports_list(), prefix="nmos_")

	# Routing the subblocks
	mos_spacing = pdk.util_max_metal_seperation()
	movey(nfet_ref, evaluate_bbox(pfet_ref)[1]+mos_spacing)
	top_level << smart_route(pdk, pfet_ref.ports["multiplier_0_source_W"], nfet_ref.ports["multiplier_0_source_W"]) # "out" of the TG
	top_level << smart_route(pdk, pfet_ref.ports["multiplier_0_drain_E"], nfet_ref.ports["multiplier_0_drain_E"]) # "in" of the TG
	return top_level

transmission_gate(pdk=sky130, width=2, length=2).show()