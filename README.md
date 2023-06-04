
    usage: ccs2ada [-h] [--targetdb TARGETDB] [--output OUTPUT] device

    Translates Texas Instruments Code Composer Studio device definitions to Ada
    package specifications

    positional arguments:
      device               Device to generate specs for. See targetdb/devices/

    optional arguments:
      -h, --help           show this help message and exit
      --targetdb TARGETDB  Path to targetdb, usually under ccs_base (default:
                           ~/ti/ccs1230/ccs/ccs_base/common/targetdb)
      --output OUTPUT      Path to output directory (default: ./gen)


Tested with [RM42L432](https://www.ti.com/product/RM42L432). Other devices might work. Good luck, send patches.
