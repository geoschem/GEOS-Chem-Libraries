HDF5 "textlink.h5" {
GROUP "/" {
   EXTERNAL_LINK "extlink1" {
      TARGETFILE "filename"
      TARGETPATH "objname"
   }
   EXTERNAL_LINK "extlink2" {
      TARGETFILE "anotherfile"
      TARGETPATH "anotherobj"
   }
}
}
HDF5-DIAG: Error detected in HDF5 (version (number)) thread (IDs):
  #000: (file name) line (number) in H5Oopen(): unable to open object
    major: Symbol table
    minor: Can't open object
  #001: (file name) line (number) in H5O_open_name(): object not found
    major: Symbol table
    minor: Object not found
  #002: (file name) line (number) in H5G_loc_find(): can't find object
    major: Symbol table
    minor: Object not found
  #003: (file name) line (number) in H5G_traverse(): internal path traversal failed
    major: Symbol table
    minor: Object not found
  #004: (file name) line (number) in H5G_traverse_real(): special link traversal failed
    major: Links
    minor: Link traversal failure
  #005: (file name) line (number) in H5G__traverse_special(): user-defined link traversal failed
    major: Links
    minor: Link traversal failure
  #006: (file name) line (number) in H5G_traverse_ud(): traversal callback returned invalid ID
    major: Symbol table
    minor: Unable to find atom information (already closed?)
  #007: (file name) line (number) in H5L_extern_traverse(): unable to open external file, external link file name = 'filename', temp_file_name = 'filename'
    major: Links
    minor: Unable to open file
HDF5-DIAG: Error detected in HDF5 (version (number)) thread (IDs):
  #000: (file name) line (number) in H5Oopen(): unable to open object
    major: Symbol table
    minor: Can't open object
  #001: (file name) line (number) in H5O_open_name(): object not found
    major: Symbol table
    minor: Object not found
  #002: (file name) line (number) in H5G_loc_find(): can't find object
    major: Symbol table
    minor: Object not found
  #003: (file name) line (number) in H5G_traverse(): internal path traversal failed
    major: Symbol table
    minor: Object not found
  #004: (file name) line (number) in H5G_traverse_real(): special link traversal failed
    major: Links
    minor: Link traversal failure
  #005: (file name) line (number) in H5G__traverse_special(): user-defined link traversal failed
    major: Links
    minor: Link traversal failure
  #006: (file name) line (number) in H5G_traverse_ud(): traversal callback returned invalid ID
    major: Symbol table
    minor: Unable to find atom information (already closed?)
  #007: (file name) line (number) in H5L_extern_traverse(): unable to open external file, external link file name = 'anotherfile', temp_file_name = 'anotherfile'
    major: Links
    minor: Unable to open file
