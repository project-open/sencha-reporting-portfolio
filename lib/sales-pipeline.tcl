# /packages/sencha-reporting-portfolio/lib/sales-pipeline.tcl
#
# Copyright (C) 2011 ]project-open[
#
# All rights reserved. Please check
# http://www.project-open.com/license/ for details.

# ----------------------------------------------------------------------
# 
# ---------------------------------------------------------------------

# The following variables are expected in the environment
# defined by the calling /tcl/*.tcl libary:
#	program_id
#	diagram_width
#	diagram_height
#	sql	Defines the columns x_axis, y_axis, color and diameter

# Create a random ID for the diagram
set diagram_id "sales_pipelin_[expr round(rand() * 100000000.0)]"

set x_axis 0
set y_axis 0
set color "yellow"
set diameter 5
set title ""
