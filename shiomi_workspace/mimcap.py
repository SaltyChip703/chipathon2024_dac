# Primitives
from glayout.flow.primitives.mimcap import mimcap
from glayout.flow.primitives.mimcap import mimcap_array

# Standard
from glayout.flow.pdk.mappedpdk import MappedPDK
from glayout.flow.pdk.sky130_mapped import sky130_mapped_pdk as sky130

# gdsfactory
from gdsfactory import Component
from gdsfactory.cell import cell
from gdsfactory.components.rectangle import rectangle

# Utility
from glayout.flow.pdk.util.comp_utils import evaluate_bbox, prec_center, prec_array

# Routing
from glayout.flow.routing.straight_route import straight_route
from glayout.flow.routing.c_route import c_route

def get_mimcap_layerconstruction_info(pdk: MappedPDK) -> tuple[str,str]:
	"""returns the glayer metal below and glayer metal above capmet
	args: pdk
	"""
	capmettop = pdk.layer_to_glayer(pdk.get_grule("capmet")["capmettop"])
	capmetbottom = pdk.layer_to_glayer(pdk.get_grule("capmet")["capmetbottom"])
	pdk.has_required_glayers(["capmet",capmettop,capmetbottom])
	pdk.activate()
	return capmettop, capmetbottom

def create_6bit_dac_mimcap_array(pdk: MappedPDK):
    """
    Creates a 6-bit DAC using an 8x8 MIM capacitor array with binary weighting.
    """
    # Create the top-level component
    dac_mim_cap = Component("6bit_DAC_MIMCAP_Array")

    '''
    # Define unit capacitor size (for example, 2x2 microns)
    unit_size = [5.0, 5.0]
    unit_mimcap = mimcap(pdk, size=unit_size)

    # Define bit weights for binary weighted capacitors
    bit_weights = [32, 16, 8, 4, 2, 1]  # From MSB to LSB
    total_units = sum(bit_weights)
    total_caps = 64  # 8x8 array
    dummy_units = total_caps - total_units  # Extra units as dummy

    # Generate common centroid indices for optimal matching
    cap_indices = [(i, j) for i in range(8) for j in range(8)]
    '''

    # metal and via layers
    met3_capmetbottom = pdk.get_glayer('met4')
    met4_capmettop = pdk.get_glayer('met5')
    via3 = pdk.get_glayer('via4')
    mimcap_arr = Component("mimcap_arr")
    #test_cap << rectangle(size=(1, 1), layer=via3)
    mimcap_single = mimcap(pdk, size=(5,5))
    rows_num = 8 
    columns_num = 8
    mimcap_space = 6*pdk.get_grule("capmet")["min_separation"]
    array_ref = mimcap_arr << prec_array(mimcap_single, rows=rows_num, columns=columns_num, spacing=2*[mimcap_space])
    mimcap_arr.add_ports(array_ref.get_ports_list())
    mim_metal_space = mimcap_space/12
    #####################
    port_pairs = list()
    for rownum in  range(rows_num):
        for colnum in range(columns_num):
            base_mimcap = f"row{rownum}_col{colnum}_"
            right_mimcap = f"row{rownum}_col{colnum+1}_"
            up_mimcap = f"row{rownum+1}_col{colnum}_"
            capmetbottom = "met4"
            capmettop = "met5"
            
            # Bottom Metal
            level = "bottom_met_"
            layer = capmetbottom
            base_east_port = mimcap_arr.ports.get(base_mimcap+level+"E")
            right_west_port = mimcap_arr.ports.get(right_mimcap+level+"W")
            base_north_port = mimcap_arr.ports.get(base_mimcap+level+"N")
            up_south_port = mimcap_arr.ports.get(up_mimcap+level+"S")
            if rownum == rows_num-1 and colnum == columns_num-1:
                continue
            elif rownum == rows_num-1:            
                port_pairs.append((base_east_port,right_west_port,layer))
            elif colnum == columns_num-1:
                port_pairs.append((base_north_port,up_south_port,layer))
            else:
                port_pairs.append((base_east_port,right_west_port,layer))
                port_pairs.append((base_north_port,up_south_port,layer))

            # Top metal
            level = "top_met_"
            position_up = "up_"
            position_down = "down_"
            position_right = "right_"
            position_left = "left_"
            layer = capmettop
            base_east_port = mimcap_arr.ports.get(base_mimcap+level+"E")
            if base_east_port is not None: 
                base_east_port_up = base_east_port.copy()
                base_east_port_up.name = base_mimcap+position_up+level+"E"
                base_east_port_up.center[1] += (base_east_port_up.width/2 - pdk.get_grule(layer)["min_width"])
                base_east_port_down = base_east_port.copy()
                base_east_port_down.name = base_mimcap+position_down+level+"E"
                base_east_port_down.center[1] -= (base_north_port.width/2 - pdk.get_grule(layer)["min_width"])
            right_west_port = mimcap_arr.ports.get(right_mimcap+level+"W")
            if right_west_port is not None:
                right_west_port_up = right_west_port.copy() 
                right_west_port_up.name = right_mimcap+position_up+level+"W"
                right_west_port_up.center[1] += (right_west_port_up.width/2 - pdk.get_grule(layer)["min_width"])
                right_west_port_down = right_west_port.copy()
                right_west_port_down.name = right_mimcap+position_down+level+"W"
                right_west_port_down.center[1] -= (right_west_port_down.width/2 - pdk.get_grule(layer)["min_width"])    
            base_north_port = mimcap_arr.ports.get(base_mimcap+level+"N")
            if base_north_port is not None:
                base_north_port_right = base_north_port.copy()
                base_north_port_right.name = base_mimcap+position_right+level+"N"
                base_north_port_right.center[0] += (base_north_port_right.width/2 - pdk.get_grule(layer)["min_width"])
                base_north_port_right_space = base_north_port_right.copy()
                base_north_port_right_space.name = base_mimcap+position_right+level+"S"
                base_north_port_right_space.center[1] += mim_metal_space*5
                base_north_port_left = base_north_port.copy()
                base_north_port_left.name = base_mimcap+position_left+level+"N"
                base_north_port_left.center[0] -= (base_north_port_left.width/2 - pdk.get_grule(layer)["min_width"])
            up_south_port = mimcap_arr.ports.get(up_mimcap+level+"S")
            if up_south_port is not None:
                up_south_port_right = up_south_port.copy()
                up_south_port_right.name = base_mimcap+position_right+level+"S"
                up_south_port_right.center[0] += (up_south_port_right.width/2 - pdk.get_grule(layer)["min_width"])
                up_south_port_left = up_south_port.copy()
                up_south_port_left.name = base_mimcap+position_left+level+"S"
                up_south_port_left.center[0] -= (up_south_port_left.width/2 - pdk.get_grule(layer)["min_width"])
                
            if rownum == rows_num-1 and colnum == columns_num-1:
                continue
            elif rownum == 0 and colnum in (2,3,5,6):
                port_pairs.append((base_north_port_right,base_north_port_right_space,layer))     
            elif rownum == rows_num-1:            
                port_pairs.append((base_east_port_up,right_west_port_up,layer))
                port_pairs.append((base_east_port_down,right_west_port_down,layer))
            elif colnum == columns_num-1:
                port_pairs.append((base_north_port_left,up_south_port_left,layer))
                port_pairs.append((base_north_port_right,up_south_port_right,layer))
            else:
                port_pairs.append((base_east_port_up,right_west_port_up,layer))
                port_pairs.append((base_east_port_down,right_west_port_down,layer))
                port_pairs.append((base_north_port_left,up_south_port_left,layer))
                port_pairs.append((base_north_port_right,up_south_port_right,layer))

            '''
            base_east_port = mimcap_arr.ports.get(base_mimcap+level+"E")
            base_east_port_up = mimcap_arr.ports.get(base_mimcap+level+"E")
            if base_east_port_up is not None:
                base_east_port_up.center[1] = base_east_port_up.width/2            
            #base_east_port_down = base_east_port
            #base_east_port_down.center[1] -= base_east_port_down.width/2
            right_west_port = mimcap_arr.ports.get(right_mimcap+level+"W")
            right_west_port_up = mimcap_arr.ports.get(right_mimcap+level+"W")
            if right_west_port_up is not None:
                right_west_port_up.center[1] = right_west_port_up.width/2
            #right_west_port_down = right_west_port
            #right_west_port_down.center[1] -= right_west_port_down.width/2
            
            
            if rownum == rows_num-1 and colnum == columns_num-1:
                continue
            elif rownum == rows_num-1:            
                port_pairs.append((base_east_port,right_west_port,layer))
                #port_pairs.append((base_east_port_down,right_west_port_down,layer))
            #elif colnum == columns_num-1:
                #port_pairs.append((base_north_port,up_south_port,layer))
            else:
                port_pairs.append((base_east_port,right_west_port,layer))
                #port_pairs.append((base_east_port_down,right_west_port_down,layer))
                #port_pairs.append((base_north_port,up_south_port,layer))
            ''' 


    for port_pair in port_pairs:
        #if port_pair[0] is None or port_pair[1] is None:
        #    continue
        mimcap_arr << straight_route(pdk, port_pair[0], port_pair[1], width=pdk.get_grule(port_pair[2])["min_width"]) 
        #print("port_pair[0]:", port_pair[0], "port_pair[1]:", port_pair[1])
        #print("-------------------------------")
        #print("port_pair[0]:", port_pair[0])
        #print("port_pair[1]:", port_pair[1])
        #print("-------------------------------")

    cap_ref = dac_mim_cap.add_ref(mimcap_arr)
    #cap_ref.movey(-30)

    '''
    # Place capacitors based on the bit weights
    cap_refs = {}
    cap_count = 0
    for bit, weight in enumerate(bit_weights):
        for _ in range(weight):
            if cap_count < total_units:
                i, j = cap_indices[cap_count]
                cap_ref = dac_mim_cap.add_ref(unit_mimcap)
                cap_ref.move((j * (unit_size[0] + pdk.get_grule("capmet")["min_separation"]),
                              i * (unit_size[1] + pdk.get_grule("capmet")["min_separation"])))
                cap_refs[f"bit{bit}_cap_{cap_count}"] = cap_ref
                cap_count += 1

    # Place dummy capacitors in remaining slots
    for d in range(dummy_units):
        if cap_count < total_caps:
            i, j = cap_indices[cap_count]
            cap_ref = dac_mim_cap.add_ref(unit_mimcap)
            cap_ref.move((j * (unit_size[0] + pdk.get_grule("capmet")["min_separation"]),
                          i * (unit_size[1] + pdk.get_grule("capmet")["min_separation"])))
            cap_count += 1
    '''
    '''
    # Routing: Connect the top and bottom electrodes of capacitors
    for bit in range(6):
        top_ports = []
        bottom_ports = []
        for key in cap_refs:
            if f"bit{bit}" in key:
                cap_ref = cap_refs[key]
                for port_name, port in cap_ref.ports.items():
                    if "top_met_" in port_name:
                        top_ports.append(port)
                    elif "bottom_met_" in port_name:
                        bottom_ports.append(port)
        
        # Connect top electrodes
        for idx in range(len(top_ports) - 1):
            route_top = straight_route(pdk, top_ports[idx], top_ports[idx + 1], layer="metal2")
            dac_mim_cap.add(route_top)
        
        # Connect bottom electrodes
        for idx in range(len(bottom_ports) - 1):
            route_bottom = straight_route(pdk, bottom_ports[idx], bottom_ports[idx + 1], layer="metal1")
            dac_mim_cap.add(route_bottom)

        # Add ports for the top and bottom of each bit's capacitors
        dac_mim_cap.add_port(name=f"bit{bit}_top", port=top_ports[0])
        dac_mim_cap.add_port(name=f"bit{bit}_bottom", port=bottom_ports[0])
    '''


    return dac_mim_cap



# Create and show the DAC MIM capacitor array layout
dac_mimcap_component = create_6bit_dac_mimcap_array(sky130).show()
