/*
 * Copyright © 2009 CNRS
 * Copyright © 2009-2018 Inria.  All rights reserved.
 * Copyright © 2009-2012, 2015, 2017 Université Bordeaux
 * Copyright © 2009-2011 Cisco Systems, Inc.  All rights reserved.
 * See COPYING in top-level directory.

 */

#include <private/autogen/config.h>
#include <hwloc.h>

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>

#include "lstopo.h"

#define SVG_TEXT_WIDTH(length, fontsize) (((length) * (fontsize))/2)
#define SVG_FONTSIZE_SCALE(size) (((size) * 11) / 9)

static void topo_native_svg_box(struct lstopo_output *loutput, const struct lstopo_color *lcolor, unsigned depth __hwloc_attribute_unused, unsigned x, unsigned width, unsigned y, unsigned height, hwloc_obj_t level, unsigned id_complement)
{
	char complement[12] = "";
	if(id_complement)
		snprintf(complement, sizeof complement, "_%d", id_complement);
	int r = lcolor->r, g = lcolor->g, b = lcolor->b;
	FILE *file = loutput->file;
	if(level){
		char type[128];
		hwloc_obj_type_snprintf(type, sizeof(type), level, 0);
		fprintf(file,"\t<rect id='%s_%d_rect%s' class='%s' x='%d' y='%d' width='%d' height='%d' style='fill:rgb(%d,%d,%d);stoke-width:1;stroke:rgb(0,0,0)'/>\n",type,level->logical_index,complement,type,x,y,width,height,r,g,b);
	}else
		fprintf(file,"\t<rect x='%d' y='%d' width='%d' height='%d' style='fill:rgb(%d,%d,%d);stoke-width:1;stroke:rgb(0,0,0)'/>\n",x,y,width,height,r,g,b);
}


static void
topo_native_svg_line(struct lstopo_output *loutput, const struct lstopo_color *lcolor, unsigned depth __hwloc_attribute_unused, unsigned x1, unsigned y1, unsigned x2, unsigned y2)
{
	FILE *file = loutput->file;
	int r = lcolor->r, g = lcolor->g, b = lcolor->b;
	fprintf(file,"\t<line x1='%d' y1='%d' x2='%d' y2='%d' style='stroke:rgb(%d,%d,%d);stroke-width:1;'/>\n",x1,y1,x2,y2,r,g,b);
}

static void
svg_textsize(struct lstopo_output *loutput __hwloc_attribute_unused, const char *text __hwloc_attribute_unused, unsigned textlength, unsigned fontsize, unsigned *width)
{
	fontsize = SVG_FONTSIZE_SCALE(fontsize);
  	*width = SVG_TEXT_WIDTH(textlength, fontsize);
}


static void
topo_native_svg_text(struct lstopo_output *loutput, const struct lstopo_color *lcolor, int size, unsigned depth __hwloc_attribute_unused, unsigned x, unsigned y, const char *text, hwloc_obj_t level, unsigned id_complement)
{
	char complement[12] = "";
	if(id_complement)
		snprintf(complement, sizeof complement, "_%d", id_complement);
	FILE *file = loutput->file;
	int r = lcolor->r, g = lcolor->g, b = lcolor->b;
	if(level){
		char type[128];
		hwloc_obj_type_snprintf(type, sizeof(type), level, 0);
		fprintf(file,"\t<text font-family='Monospace' id='%s_%d_text%s' class='%s' x='%d' y='%d' fill='rgb(%d,%d,%d)' style='font-size:%dpx'>%s</text>\n",type,level->logical_index,complement,type,x,y+size,r,g,b,size,text);
	}else
		fprintf(file,"\t<text font-family='Monospace' x='%d' y='%d' fill='rgb(%d,%d,%d)' style='font-size:%d'>%s</text>\n",x,y+size,r,g,b,size,text);
}


static struct draw_methods native_svg_draw_methods = {
	NULL,
	topo_native_svg_box,
	topo_native_svg_line,
	topo_native_svg_text,
	svg_textsize,
};



int output_svg(struct lstopo_output * loutput, const char *filename)
{
	FILE *output = open_output(filename, loutput->overwrite);
	if (!output) {
		fprintf(stderr, "Failed to open %s for writing (%s)\n", filename, strerror(errno));
		return -1;
	}
	loutput->file = output;
	loutput->methods = &native_svg_draw_methods;

	/* recurse once for preparing sizes and positions */
	loutput->drawing = LSTOPO_DRAWING_PREPARE;
	output_draw(loutput);
	loutput->drawing = LSTOPO_DRAWING_DRAW;
	lstopo_prepare_custom_styles(loutput);

	
	fprintf(output,"%s","<?xml version='1.0' encoding='UTF-8'?>\n");
	fprintf(output,"<svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' width='%dpx' height='%dpx' viewBox='0 0 %dpx %dpx' version='1.1'>\n",loutput->width,loutput->height,loutput->width,loutput->height);
	
	output_draw(loutput);
	fprintf(output,"</svg>\n");

	if (output != stdout)
    fclose(output);

	return 0;
}