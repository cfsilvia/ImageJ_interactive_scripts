#@ch.epfl.biop.atlas.aligner.MultiSlicePositioner msp


DecimalFormat df = new DecimalFormat("00.000");
DecimalFormat df2 = new DecimalFormat(".0");

println("- Atlas info")

println("Name \t Resolution (um) \t Cutting angle X (rad) \t Cutting angle Y (rad)")

println(msp.getAtlas().toString()+"\t"+(int) (msp.getAtlas().getMap().getAtlasPrecisionInMillimeter()*1000)+"\t"+msp.getReslicedAtlas().getRotateX()+"\t"+msp.getReslicedAtlas().getRotateY())


println("- Slices info")

println("Name \t Z (mm) \t Thickness (um)")

for (slice : msp.getSlices()) {
	double zPositionMm = slice.getSlicingAxisPosition()-msp.getReslicedAtlas().getZOffset()
	double zThicknessUm = slice.getThicknessInMm()*1000
	println(slice.getName()+"\t"+df.format(zPositionMm)+"\t"+df2.format(zThicknessUm))
}

import java.text.DecimalFormat