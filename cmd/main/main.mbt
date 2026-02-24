///|
fn print_usage() -> Unit {
  println("usage: grib2_mbt <grib2-file> [option]")
  println("options:")
  println("  -s      print inventory lines")
  println("  -Sec0   print section0 summary lines")
  println("  -Sec3   print section3 summary lines")
  println("  -Sec4   print section4 summary lines")
  println("  -Sec5   print section5 summary lines")
  println("  -Sec6   print section6 summary lines")
  println("  -Sec_len  print section length summary lines")
  println("  -n      print record indices")
  println("  -range  print byte ranges")
  println("  -var    print variable names")
  println("  -lev    print level names")
  println("  -ftime  print forecast time labels")
  println("  -t      print reference time YYYYMMDDHH")
  println("  -T      print reference time YYYYMMDDHHMMSS")
  println("  -vt     print verification time YYYYMMDDHH")
  println("  -VT     print verification time YYYYMMDDHHMMSS")
  println("  -YY     print reference year YYYY")
  println("  -MM     print reference month MM")
  println("  -RT     print type of reference time")
  println("  -start_ft  print forecast start time YYYYMMDDHH")
  println("  -start_FT  print forecast start time YYYYMMDDHHMMSS")
  println("  -end_ft  print forecast end time YYYYMMDDHH")
  println("  -end_FT  print forecast end time YYYYMMDDHHMMSS")
  println("  -S      print inventory with D=YYYYMMDDHHMMSS")
  println("  -verf   print inventory using verification time")
  println("  -unix_time  print unix timestamps")
  println("  -grid   print grid description lines")
  println("  -pdt    print product definition template numbers")
  println("  -process  print process type (code table 4.3)")
  println("  -ens    print ensemble information")
  println("  -prob   print probability information")
  println("  -disc   print discipline information")
  println("  -center  print center id")
  println("  -subcenter  print subcenter id")
  println("  -packing  print packing mode")
  println("  -bitmap  print bitmap mode")
  println("  -nxny   print grid nx/ny")
  println("  -npts   print total grid points")
  println("  -var -lev  print variable and level lines")
  println("  -code_table_0.0  print discipline (code table 0.0)")
  println("  -code_table_1.0  print master tables version (code table 1.0)")
  println("  -code_table_1.1  print local tables version (code table 1.1)")
  println("  -code_table_1.2  print significance of reference time (code table 1.2)")
  println("  -code_table_1.3  print production status (code table 1.3)")
  println("  -code_table_1.4  print type of data (code table 1.4)")
  println("  -code_table_3.0  print source of grid definition (code table 3.0)")
  println("  -code_table_3.1  print grid definition template (code table 3.1)")
  println("  -code_table_6.0  print bitmap indicator (code table 6.0)")
  println("  -code_table_4.0  print product definition template (code table 4.0)")
  println("  -code_table_4.1  print parameter category (code table 4.1)")
  println("  -code_table_4.2  print parameter number (code table 4.2)")
  println("  -code_table_4.3  print process type (code table 4.3)")
  println("  -code_table_4.4  print unit of time range (code table 4.4)")
  println("  -code_table_5.0  print data representation template (code table 5.0)")
  println("  -flag_table_3.3  print resolution and component flags")
  println("  -flag_table_3.4  print scanning mode")
  println("  -flag_table_3.5  print projection center flags")
  println("  -flag_table_3.9  print numbering order of diamonds")
  println("  -flag_table_3.10  print scanning mode for one diamond")
  println("  -scan   print scanning mode with input/output")
  println("  -ext_name  print extended parameter name")
  println("  -full_name  print VAR.LEVEL format")
  println("  -lev0   print simple level name")
  println("  -cyclic  print grid cyclic status")
  println("  -domain  print N/S/W/E grid bounds")
  println("  -scale  print decimal/binary scale factors")
  println("  -scaling  print scaling parameters")
  println("  -radius  print earth radius information")
  println("  -varX  print extended variable identifier")
  println("  -grid_id  print grid identification")
  println("  -nl  add blank line after each record")
  println("  -misc  print miscellaneous inventory")
  println("  -Match_inv  print comprehensive match inventory")
  println("  -code_table_3.2  print earth shape (code table 3.2)")
  println("  -code_table_4.5a  print first surface type (code table 4.5)")
  println("  -code_table_4.5b  print second surface type (code table 4.5)")
  println("  -code_table_1.5  print identification template number")
  println("  -code_table_1.6  print calendar")
  println("  -code_table_4.6  print ensemble type")
  println("  -code_table_4.9  print probability type")
  println("  -code_table_4.10  print statistical processing type")
  println("  -code_table_4.11  print type of time intervals")
  println("  -code_table_3.11  print regional/global thinned/reduced grid")
  println("  -code_table_5.1  print type of original field values")
  println("  -code_table_3.6  print spectral data representation type")
  println("  -code_table_3.7  print spectral data representation mode")
  println("  -code_table_3.8  print grid point position")
  println("  -code_table_3.15  print physical meaning of vertical coordinate")
  println("  -code_table_3.20  print type of horizontal line")
  println("  -code_table_3.21  print vertical dimension coordinate values")
  println("  -code_table_4.7  print derived forecast type")
  println("  -code_table_4.8  print cluster mean type")
  println("  -code_table_4.11s  print type of time intervals (all)")
  println("  -code_table_4.15  print type of areal statistical processing")
  println("  -code_table_4.16  print quality control value")
  println("  -code_table_4.91  print type of interval")
  println("  -code_table_4.91b  print type of interval (2nd)")
  println("  -code_table_4.230  print chemical constituent type")
  println("  -code_table_4.233  print aerosol type")
  println("  -code_table_4.235  print wind-generated wave spectral description")
  println("  -code_table_4.240  print type of distribution function")
  println("  -code_table_4.241  print coverage attributes")
  println("  -code_table_4.242  print tile classification")
  println("  -code_table_5.4  print group splitting method")
  println("  -code_table_5.5  print missing value management")
  println("  -code_table_5.6  print spatial differencing")
  println("  -code_table_5.7  print precision in IEEE packing")
  println("  -ftime1  print forecast time (same as -ftime)")
  println("  -s2  print simple inventory")
  println("  -pds_fcst_time  print forecast time in PDS units")
  println("  -type_reftime  print type of reference time")
  println("  -table  print parameter table info")
  println("  -vector_dir  print wind direction type")
  println("  -precision  print packing precision")
  println("  -number_of_coordinate_values_after_template  print coordinate values count")
  println("  -N_ens  print number of ensemble members")
  println("  -N_clusters  print number of clusters")
  println("  -aerosol_size  print aerosol size")
  println("  -aerosol_wavelength  print aerosol wavelength")
  println("  -cluster  print cluster identifier")
  println("  -cluster_info  print cluster information")
  println("  -model_version_date  print model version date")
  println("  -percent  print percentage probability")
  println("  -post_processing  print post-processing type")
  println("  -spatial_proc  print spatial processing")
  println("  -spectral_bands  print spectral bands")
  println("  -ctl_ens  print ensemble info for GrADS")
  println("  -warn_old_g2  print old g2lib warnings")
  println("  -wave_partition  print wave partition")
  println("  -processid  print process identifiers")
  println("  -ftime2  print forecast time (future replacement)")
  println("  -geolocation  print geolocation package")
  println("  -JMA  print JMA locally defined PDT")
  println("  -JMA_Nb  print JMA Nb value")
  println("  -JMA_Nr  print JMA Nr value")
  println("  -reset_delayed_error  clear delayed error flag")
  println("  -ftn_api_fn0  print Fortran API format")
  println("  -grib_max_bits  print maximum bits used in encoding")
  println("  -hybrid  print hybrid vertical coordinates")
  println("  -V  print diagnostic output")
  println("  -crlf  use CRLF line endings")
  println("  -inv  print standard inventory")
}

///|
fn print_lines(lines : Array[String]) -> Unit {
  for line in lines {
    println(line)
  }
}

///|
fn native_read_bytes(path : String) -> Result[Bytes, String] {
  try @fs.read_file_to_bytes(path) catch {
    error => Err("failed to read file: " + error.to_string())
  } noraise {
    bytes => Ok(bytes)
  }
}

///|
fn parse_mode(args : Array[String]) -> @lib.Grib2InventoryMode? {
  if args.length() == 0 || (args.length() == 1 && args[0] == "-s") {
    return Some(InventoryShort)
  }
  if args.length() == 1 && args[0] == "-Sec0" {
    return Some(InventorySec0)
  }
  if args.length() == 1 && args[0] == "-Sec3" {
    return Some(InventorySec3)
  }
  if args.length() == 1 && args[0] == "-Sec4" {
    return Some(InventorySec4)
  }
  if args.length() == 1 && args[0] == "-Sec5" {
    return Some(InventorySec5)
  }
  if args.length() == 1 && args[0] == "-Sec6" {
    return Some(InventorySec6)
  }
  if args.length() == 1 && args[0] == "-Sec_len" {
    return Some(InventorySecLen)
  }
  if args.length() == 1 && args[0] == "-n" {
    return Some(InventoryN)
  }
  if args.length() == 1 && args[0] == "-range" {
    return Some(InventoryRange)
  }
  if args.length() == 1 && args[0] == "-var" {
    return Some(InventoryVar)
  }
  if args.length() == 1 && args[0] == "-lev" {
    return Some(InventoryLev)
  }
  if args.length() == 1 && args[0] == "-ftime" {
    return Some(InventoryFtime)
  }
  if args.length() == 1 && args[0] == "-t" {
    return Some(InventoryT)
  }
  if args.length() == 1 && args[0] == "-vt" {
    return Some(InventoryVt)
  }
  if args.length() == 1 && args[0] == "-T" {
    return Some(InventoryTFull)
  }
  if args.length() == 1 && args[0] == "-VT" {
    return Some(InventoryVtFull)
  }
  if args.length() == 1 && args[0] == "-YY" {
    return Some(InventoryYY)
  }
  if args.length() == 1 && args[0] == "-MM" {
    return Some(InventoryMM)
  }
  if args.length() == 1 && args[0] == "-RT" {
    return Some(InventoryRT)
  }
  if args.length() == 1 && args[0] == "-start_ft" {
    return Some(InventoryStartFt)
  }
  if args.length() == 1 && args[0] == "-start_FT" {
    return Some(InventoryStartFT)
  }
  if args.length() == 1 && args[0] == "-end_ft" {
    return Some(InventoryEndFt)
  }
  if args.length() == 1 && args[0] == "-end_FT" {
    return Some(InventoryEndFT)
  }
  if args.length() == 1 && args[0] == "-S" {
    return Some(InventoryS)
  }
  if args.length() == 1 && args[0] == "-verf" {
    return Some(InventoryVerf)
  }
  if args.length() == 1 && args[0] == "-unix_time" {
    return Some(InventoryUnixTime)
  }
  if args.length() == 1 && args[0] == "-grid" {
    return Some(InventoryGrid)
  }
  if args.length() == 1 && args[0] == "-pdt" {
    return Some(InventoryPdt)
  }
  if args.length() == 1 && args[0] == "-process" {
    return Some(InventoryProcess)
  }
  if args.length() == 1 && args[0] == "-ens" {
    return Some(InventoryEns)
  }
  if args.length() == 1 && args[0] == "-prob" {
    return Some(InventoryProb)
  }
  if args.length() == 1 && args[0] == "-disc" {
    return Some(InventoryDisc)
  }
  if args.length() == 1 && args[0] == "-center" {
    return Some(InventoryCenter)
  }
  if args.length() == 1 && args[0] == "-subcenter" {
    return Some(InventorySubcenter)
  }
  if args.length() == 1 && args[0] == "-packing" {
    return Some(InventoryPacking)
  }
  if args.length() == 1 && args[0] == "-bitmap" {
    return Some(InventoryBitmap)
  }
  if args.length() == 1 && args[0] == "-nxny" {
    return Some(InventoryNxny)
  }
  if args.length() == 1 && args[0] == "-npts" {
    return Some(InventoryNpts)
  }
  if args.length() == 2 && args[0] == "-var" && args[1] == "-lev" {
    return Some(InventoryVarLev)
  }
  if args.length() == 1 && args[0] == "-code_table_0.0" {
    return Some(InventoryCodeTable00)
  }
  if args.length() == 1 && args[0] == "-code_table_1.0" {
    return Some(InventoryCodeTable10)
  }
  if args.length() == 1 && args[0] == "-code_table_1.1" {
    return Some(InventoryCodeTable11)
  }
  if args.length() == 1 && args[0] == "-code_table_1.2" {
    return Some(InventoryCodeTable12)
  }
  if args.length() == 1 && args[0] == "-code_table_1.3" {
    return Some(InventoryCodeTable13)
  }
  if args.length() == 1 && args[0] == "-code_table_1.4" {
    return Some(InventoryCodeTable14)
  }
  if args.length() == 1 && args[0] == "-code_table_3.0" {
    return Some(InventoryCodeTable30)
  }
  if args.length() == 1 && args[0] == "-code_table_3.1" {
    return Some(InventoryCodeTable31)
  }
  if args.length() == 1 && args[0] == "-code_table_6.0" {
    return Some(InventoryCodeTable60)
  }
  if args.length() == 1 && args[0] == "-code_table_4.0" {
    return Some(InventoryCodeTable40)
  }
  if args.length() == 1 && args[0] == "-code_table_4.1" {
    return Some(InventoryCodeTable41)
  }
  if args.length() == 1 && args[0] == "-code_table_4.2" {
    return Some(InventoryCodeTable42)
  }
  if args.length() == 1 && args[0] == "-code_table_4.3" {
    return Some(InventoryCodeTable43)
  }
  if args.length() == 1 && args[0] == "-code_table_4.4" {
    return Some(InventoryCodeTable44)
  }
  if args.length() == 1 && args[0] == "-code_table_5.0" {
    return Some(InventoryCodeTable50)
  }
  if args.length() == 1 && args[0] == "-flag_table_3.3" {
    return Some(InventoryFlagTable33)
  }
  if args.length() == 1 && args[0] == "-flag_table_3.4" {
    return Some(InventoryFlagTable34)
  }
  if args.length() == 1 && args[0] == "-flag_table_3.5" {
    return Some(InventoryFlagTable35)
  }
  if args.length() == 1 && args[0] == "-flag_table_3.9" {
    return Some(InventoryFlagTable39)
  }
  if args.length() == 1 && args[0] == "-flag_table_3.10" {
    return Some(InventoryFlagTable310)
  }
  if args.length() == 1 && args[0] == "-scan" {
    return Some(InventoryScan)
  }
  if args.length() == 1 && args[0] == "-ext_name" {
    return Some(InventoryExtName)
  }
  if args.length() == 1 && args[0] == "-full_name" {
    return Some(InventoryFullName)
  }
  if args.length() == 1 && args[0] == "-lev0" {
    return Some(InventoryLev0)
  }
  if args.length() == 1 && args[0] == "-cyclic" {
    return Some(InventoryCyclic)
  }
  if args.length() == 1 && args[0] == "-domain" {
    return Some(InventoryDomain)
  }
  if args.length() == 1 && args[0] == "-scale" {
    return Some(InventoryScale)
  }
  if args.length() == 1 && args[0] == "-scaling" {
    return Some(InventoryScaling)
  }
  if args.length() == 1 && args[0] == "-radius" {
    return Some(InventoryRadius)
  }
  if args.length() == 1 && args[0] == "-varX" {
    return Some(InventoryVarX)
  }
  if args.length() == 1 && args[0] == "-grid_id" {
    return Some(InventoryGridId)
  }
  if args.length() == 1 && args[0] == "-nl" {
    return Some(InventoryNl)
  }
  if args.length() == 1 && args[0] == "-misc" {
    return Some(InventoryMisc)
  }
  if args.length() == 1 && args[0] == "-Match_inv" {
    return Some(InventoryMatchInv)
  }
  if args.length() == 1 && args[0] == "-code_table_3.2" {
    return Some(InventoryCodeTable32)
  }
  if args.length() == 1 && args[0] == "-code_table_4.5a" {
    return Some(InventoryCodeTable45a)
  }
  if args.length() == 1 && args[0] == "-code_table_4.5b" {
    return Some(InventoryCodeTable45b)
  }
  if args.length() == 1 && args[0] == "-code_table_1.5" {
    return Some(InventoryCodeTable15)
  }
  if args.length() == 1 && args[0] == "-code_table_1.6" {
    return Some(InventoryCodeTable16)
  }
  if args.length() == 1 && args[0] == "-code_table_4.6" {
    return Some(InventoryCodeTable46)
  }
  if args.length() == 1 && args[0] == "-code_table_4.9" {
    return Some(InventoryCodeTable49)
  }
  if args.length() == 1 && args[0] == "-code_table_4.10" {
    return Some(InventoryCodeTable410)
  }
  if args.length() == 1 && args[0] == "-code_table_4.11" {
    return Some(InventoryCodeTable411)
  }
  if args.length() == 1 && args[0] == "-code_table_3.11" {
    return Some(InventoryCodeTable311)
  }
  if args.length() == 1 && args[0] == "-code_table_5.1" {
    return Some(InventoryCodeTable51)
  }
  if args.length() == 1 && args[0] == "-code_table_3.6" {
    return Some(InventoryCodeTable36)
  }
  if args.length() == 1 && args[0] == "-code_table_3.7" {
    return Some(InventoryCodeTable37)
  }
  if args.length() == 1 && args[0] == "-code_table_3.8" {
    return Some(InventoryCodeTable38)
  }
  if args.length() == 1 && args[0] == "-code_table_3.15" {
    return Some(InventoryCodeTable315)
  }
  if args.length() == 1 && args[0] == "-code_table_3.20" {
    return Some(InventoryCodeTable320)
  }
  if args.length() == 1 && args[0] == "-code_table_3.21" {
    return Some(InventoryCodeTable321)
  }
  if args.length() == 1 && args[0] == "-code_table_4.7" {
    return Some(InventoryCodeTable47)
  }
  if args.length() == 1 && args[0] == "-code_table_4.8" {
    return Some(InventoryCodeTable48)
  }
  if args.length() == 1 && args[0] == "-code_table_4.11s" {
    return Some(InventoryCodeTable411s)
  }
  if args.length() == 1 && args[0] == "-code_table_4.15" {
    return Some(InventoryCodeTable415)
  }
  if args.length() == 1 && args[0] == "-code_table_4.16" {
    return Some(InventoryCodeTable416)
  }
  if args.length() == 1 && args[0] == "-code_table_4.91" {
    return Some(InventoryCodeTable491)
  }
  if args.length() == 1 && args[0] == "-code_table_4.91b" {
    return Some(InventoryCodeTable491b)
  }
  if args.length() == 1 && args[0] == "-code_table_4.230" {
    return Some(InventoryCodeTable4230)
  }
  if args.length() == 1 && args[0] == "-code_table_4.233" {
    return Some(InventoryCodeTable4233)
  }
  if args.length() == 1 && args[0] == "-code_table_4.235" {
    return Some(InventoryCodeTable4235)
  }
  if args.length() == 1 && args[0] == "-code_table_4.240" {
    return Some(InventoryCodeTable4240)
  }
  if args.length() == 1 && args[0] == "-code_table_4.241" {
    return Some(InventoryCodeTable4241)
  }
  if args.length() == 1 && args[0] == "-code_table_4.242" {
    return Some(InventoryCodeTable4242)
  }
  if args.length() == 1 && args[0] == "-code_table_5.4" {
    return Some(InventoryCodeTable54)
  }
  if args.length() == 1 && args[0] == "-code_table_5.5" {
    return Some(InventoryCodeTable55)
  }
  if args.length() == 1 && args[0] == "-code_table_5.6" {
    return Some(InventoryCodeTable56)
  }
  if args.length() == 1 && args[0] == "-code_table_5.7" {
    return Some(InventoryCodeTable57)
  }
  if args.length() == 1 && args[0] == "-ftime1" {
    return Some(InventoryFtime1)
  }
  if args.length() == 1 && args[0] == "-s2" {
    return Some(InventoryS2)
  }
  if args.length() == 1 && args[0] == "-pds_fcst_time" {
    return Some(InventoryPdsFcstTime)
  }
  if args.length() == 1 && args[0] == "-type_reftime" {
    return Some(InventoryTypeReftime)
  }
  if args.length() == 1 && args[0] == "-table" {
    return Some(InventoryTable)
  }
  if args.length() == 1 && args[0] == "-vector_dir" {
    return Some(InventoryVectorDir)
  }
  if args.length() == 1 && args[0] == "-precision" {
    return Some(InventoryPrecision)
  }
  if args.length() == 1 && args[0] == "-number_of_coordinate_values_after_template" {
    return Some(InventoryNumCoordValues)
  }
  if args.length() == 1 && args[0] == "-N_ens" {
    return Some(InventoryNEns)
  }
  if args.length() == 1 && args[0] == "-N_clusters" {
    return Some(InventoryNClusters)
  }
  if args.length() == 1 && args[0] == "-aerosol_size" {
    return Some(InventoryAerosolSize)
  }
  if args.length() == 1 && args[0] == "-aerosol_wavelength" {
    return Some(InventoryAerosolWavelength)
  }
  if args.length() == 1 && args[0] == "-cluster" {
    return Some(InventoryCluster)
  }
  if args.length() == 1 && args[0] == "-cluster_info" {
    return Some(InventoryClusterInfo)
  }
  if args.length() == 1 && args[0] == "-model_version_date" {
    return Some(InventoryModelVersionDate)
  }
  if args.length() == 1 && args[0] == "-percent" {
    return Some(InventoryPercent)
  }
  if args.length() == 1 && args[0] == "-post_processing" {
    return Some(InventoryPostProcessing)
  }
  if args.length() == 1 && args[0] == "-spatial_proc" {
    return Some(InventorySpatialProc)
  }
  if args.length() == 1 && args[0] == "-spectral_bands" {
    return Some(InventorySpectralBands)
  }
  if args.length() == 1 && args[0] == "-ctl_ens" {
    return Some(InventoryCtlEns)
  }
  if args.length() == 1 && args[0] == "-warn_old_g2" {
    return Some(InventoryWarnOldG2)
  }
  if args.length() == 1 && args[0] == "-wave_partition" {
    return Some(InventoryWavePartition)
  }
  if args.length() == 1 && args[0] == "-processid" {
    return Some(InventoryProcessId)
  }
  if args.length() == 1 && args[0] == "-ftime2" {
    return Some(InventoryFtime2)
  }
  if args.length() == 1 && args[0] == "-geolocation" {
    return Some(InventoryGeolocation)
  }
  if args.length() == 1 && args[0] == "-JMA" {
    return Some(InventoryJMA)
  }
  if args.length() == 1 && args[0] == "-JMA_Nb" {
    return Some(InventoryJMANb)
  }
  if args.length() == 1 && args[0] == "-JMA_Nr" {
    return Some(InventoryJMANr)
  }
  if args.length() == 1 && args[0] == "-reset_delayed_error" {
    return Some(InventoryResetDelayedError)
  }
  if args.length() == 1 && args[0] == "-ftn_api_fn0" {
    return Some(InventoryFtnApiFn0)
  }
  if args.length() == 1 && args[0] == "-grib_max_bits" {
    return Some(InventoryGribMaxBits)
  }
  if args.length() == 1 && args[0] == "-hybrid" {
    return Some(InventoryHybrid)
  }
  if args.length() == 1 && args[0] == "-V" {
    return Some(InventoryVerbose)
  }
  if args.length() == 1 && args[0] == "-crlf" {
    return Some(InventoryCrlf)
  }
  if args.length() == 1 && args[0] == "-inv" {
    return Some(InventoryInv)
  }
  None
}

///|
fn run_cli(args : Array[String]) -> Int {
  if args.length() < 2 {
    print_usage()
    return 1
  }
  if args.length() > 4 {
    println("error: too many arguments")
    print_usage()
    return 1
  }
  let file_path = args[1]
  let rest = if args.length() > 2 { [args[2], ..args[3:]] } else { [] }
  let mode = match parse_mode(rest) {
    Some(mode) => mode
    None => {
      println("error: unsupported option")
      println(
        "supported options: -s, -Sec0, -Sec3, -Sec4, -Sec5, -Sec6, -Sec_len, -n, -range, -var, -lev, -ftime, -t, -T, -vt, -VT, -YY, -MM, -grid, -pdt, -process, -ens, -prob, -disc, -center, -subcenter, -packing, -bitmap, -nxny, -npts, -var -lev",
      )
      return 3
    }
  }
  let lines = match
    @lib.render_inventory_lines_with_io(native_read_bytes, file_path, mode) {
    Ok(lines) => lines
    Err(error) => {
      println("error: " + error.to_string())
      return 2
    }
  }
  print_lines(lines)
  0
}

///|
fn main {
  let args = @sys.get_cli_args()
  let exit_code = run_cli(args)
  @sys.exit(exit_code)
}
