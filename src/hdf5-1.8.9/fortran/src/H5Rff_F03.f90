!****h* ROBODoc/H5R (F03)
!
! NAME
!  MODULE H5R_PROVISIONAL
!
! FILE
!  fortran/src/H5Rff_F03.f90
!
! PURPOSE
!  This file contains Fortran 90 and Fortran 2003 interfaces for H5R functions.
!  It contains the same functions as H5Rff_DEPRECIATE.f90 but includes the
!  Fortran 2003 functions and the interface listings. This file will be compiled
!  instead of H5Rff_DEPRECIATE.f90 if Fortran 2003 functions are enabled.
!
! COPYRIGHT
!  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
!  Copyright by The HDF Group.                                               *
!  Copyright by the Board of Trustees of the University of Illinois.         *
!  All rights reserved.                                                      *
!  *
!  This file is part of HDF5.  The full HDF5 copyright notice, including     *
!  terms governing use, modification, and redistribution, is contained in    *
!  the files COPYING and Copyright.html.  COPYING can be found at the root   *
!  of the source code distribution tree; Copyright.html can be found at the  *
!  root level of an installed copy of the electronic HDF5 document set and   *
!  is linked from the top-level documents page.  It can also be found at     *
!  http://hdfgroup.org/HDF5/doc/Copyright.html.  If you do not have          *
!  access to either file, you may request a copy from help@hdfgroup.org.     *
!  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
!
! NOTES
!                         *** IMPORTANT ***
!  If you add a new H5R function you must add the function name to the
!  Windows dll file 'hdf5_fortrandll.def' in the fortran/src directory.
!  This is needed for Windows based operating systems.
!
!*****
MODULE H5R_PROVISIONAL
  USE H5GLOBAL

  ! If you change the value of these parameters, do not forget to change corresponding
  ! values in the H5f90.h file.
  !        INTEGER, PARAMETER :: REF_OBJ_BUF_LEN = 2
  !        INTEGER, PARAMETER :: REF_REG_BUF_LEN = 3
  !
  !        TYPE hobj_ref_t_f
  !             INTEGER ref(REF_OBJ_BUF_LEN)
  !        END TYPE
  !
  !        TYPE hdset_reg_ref_t_f
  !             INTEGER ref(REF_REG_BUF_LEN)
  !        END TYPE
  !
  INTERFACE h5rcreate_f

     MODULE PROCEDURE h5rcreate_object_f ! obsolete
     MODULE PROCEDURE h5rcreate_region_f ! obsolete
     MODULE PROCEDURE h5rcreate_ptr_f  ! F2003

  END INTERFACE

  INTERFACE h5rdereference_f

     MODULE PROCEDURE h5rdereference_object_f ! obsolete
     MODULE PROCEDURE h5rdereference_region_f ! obsolete
     MODULE PROCEDURE h5rdereference_ptr_f ! F2003

  END INTERFACE

  INTERFACE h5rget_name_f

     MODULE PROCEDURE h5rget_name_object_f ! obsolete
     MODULE PROCEDURE h5rget_name_region_f ! obsolete
     MODULE PROCEDURE h5rget_name_ptr_f ! F2003

  END INTERFACE

  INTERFACE
     INTEGER FUNCTION h5rget_name_ptr_c(loc_id, ref_type, ref, name, name_len, size_default)
       USE, INTRINSIC :: ISO_C_BINDING
       USE H5GLOBAL
       !DEC$IF DEFINED(HDF5F90_WINDOWS)
       !DEC$ATTRIBUTES C,reference,decorate,alias:'H5RGET_NAME_PTR_C':: h5rget_name_ptr_c
       !DEC$ENDIF
       !DEC$ATTRIBUTES reference :: name
       INTEGER(HID_T), INTENT(IN) :: loc_id
       INTEGER, INTENT(IN) :: ref_type
       TYPE(C_PTR), INTENT(IN), VALUE :: ref
       CHARACTER(LEN=*), INTENT(OUT) :: name
       INTEGER(SIZE_T) :: name_len
       INTEGER(SIZE_T) :: size_default
     END FUNCTION h5rget_name_ptr_c
  END INTERFACE

  INTERFACE
     INTEGER FUNCTION h5rdereference_ptr_c(obj_id, ref_type, ref, ref_obj_id)
       USE H5GLOBAL
       USE, INTRINSIC :: ISO_C_BINDING
       !DEC$IF DEFINED(HDF5F90_WINDOWS)
       !DEC$ATTRIBUTES C,reference,decorate,alias:'H5RDEREFERENCE_PTR_C':: h5rdereference_ptr_c
       !DEC$ENDIF
       INTEGER(HID_T), INTENT(IN) :: obj_id
       INTEGER, INTENT(IN) :: ref_type
       TYPE(C_PTR), INTENT(IN), VALUE :: ref
       INTEGER(HID_T), INTENT(OUT) :: ref_obj_id
     END FUNCTION h5rdereference_ptr_c
  END INTERFACE

  INTERFACE
     INTEGER FUNCTION h5rcreate_ptr_c(ref, loc_id, name, namelen, ref_type, space_id)
       USE, INTRINSIC :: ISO_C_BINDING
       USE H5GLOBAL
       !DEC$IF DEFINED(HDF5F90_WINDOWS)
       !DEC$ATTRIBUTES C,reference,decorate,alias:'H5RCREATE_PTR_C':: h5rcreate_ptr_c
       !DEC$ENDIF
       !DEC$ATTRIBUTES reference :: name
       TYPE(C_PTR), VALUE :: ref
       INTEGER(HID_T), INTENT(IN) :: loc_id
       CHARACTER(LEN=*), INTENT(IN) :: name
       INTEGER :: namelen
       INTEGER, INTENT(IN) :: ref_type
       INTEGER(HID_T), INTENT(IN) :: space_id
     END FUNCTION h5rcreate_ptr_c
  END INTERFACE

CONTAINS

!****s* H5R (F03)/h5rcreate_object_f
!
! NAME
!  h5rcreate_object_f
!
! PURPOSE
!  Creates reference to the object
!
! Inputs:
!  loc_id    - location identifier
!  name      - name of the object at the specified location
! Outputs:
!  ref 	     - reference to the specified object
!  hdferr:   - error code
!               Success:  0
!               Failure: -1
! AUTHOR
!  Elena Pourmal
!  August 12, 1999
!
! HISTORY
!  Explicit Fortran interfaces were added for
!  called C functions (it is needed for Windows
!  port).  February 28, 2001
!
! NOTES
!  This is a module procedure for the h5rcreate_f subroutine.
!
! Signature:
  SUBROUTINE h5rcreate_object_f(loc_id, name, ref, hdferr)
    USE, INTRINSIC :: ISO_C_BINDING
    IMPLICIT NONE
    INTEGER(HID_T), INTENT(IN) :: loc_id   ! Location identifier
    CHARACTER(LEN=*), INTENT(IN) :: name   ! Name of the object at location specified
                                           ! by loc_id identifier
    TYPE(hobj_ref_t_f), INTENT(INOUT), TARGET :: ref   ! Object reference
    INTEGER, INTENT(OUT) :: hdferr         ! Error code
!*****
    INTEGER :: namelen                     ! Name length

    TYPE(C_PTR) :: f_ptr

    f_ptr = C_LOC(ref)

    namelen = LEN(name)

    hdferr = h5rcreate_ptr_c(f_ptr, loc_id, name, namelen, INT(0), INT(-1,HID_T))

  END SUBROUTINE h5rcreate_object_f

!****s* H5R (F03)/h5rcreate_region_f
!
! NAME
!  h5rcreate_region_f
!
! PURPOSE
!  Creates reference to the dataset region
!
! Inputs:
!  loc_id 	 - location identifier
!  name 	 - name of the dataset at the specified location
!  space_id 	 - dataspace identifier that describes selected region
! Outputs:
!  ref 	         - reference to the dataset region
!  hdferr:	 - error code
!                   Success:  0
!                   Failure: -1
!
! AUTHOR
!  Elena Pourmal
!  August 12, 1999
!
! HISTORY
!  Explicit Fortran interfaces were added for
!  called C functions (it is needed for Windows
!  port).  February 28, 2001
!
! NOTES
!  This is a module procedure for the h5rcreate_f subroutine.
!
! Signature:
  SUBROUTINE h5rcreate_region_f(loc_id, name, space_id, ref, hdferr)
    USE, INTRINSIC :: ISO_C_BINDING
    IMPLICIT NONE
    INTEGER(HID_T), INTENT(IN) :: loc_id   ! Location identifier
    CHARACTER(LEN=*), INTENT(IN) :: name   ! Name of the dataset at location specified
                                           ! by loc_id identifier
    INTEGER(HID_T), INTENT(IN) :: space_id ! Dataset's dataspace identifier
    TYPE(hdset_reg_ref_t_f), INTENT(INOUT), TARGET :: ref ! Dataset region reference
    INTEGER, INTENT(OUT) :: hdferr         ! Error code
!*****
    INTEGER :: namelen                     ! Name length
    INTEGER :: ref_f(REF_REG_BUF_LEN)      ! Local buffer to pass reference

    TYPE(C_PTR) :: f_ptr

!  !$    INTERFACE
!  !$       INTEGER FUNCTION h5rcreate_region_c(ref_f, loc_id, name, namelen, space_id)
!  !$         USE H5GLOBAL
!  !$         !DEC$IF DEFINED(HDF5F90_WINDOWS)
!  !$         !DEC$ATTRIBUTES C,reference,decorate,alias:'H5RCREATE_REGION_C':: h5rcreate_region_c
!  !$         !DEC$ENDIF
!  !$         !DEC$ATTRIBUTES reference :: name
!  !$         !              INTEGER, PARAMETER :: REF_REG_BUF_LEN = 3
!  !$         INTEGER :: ref_f(REF_REG_BUF_LEN)
!  !$         INTEGER(HID_T), INTENT(IN) :: loc_id
!  !$         CHARACTER(LEN=*), INTENT(IN) :: name
!  !$         INTEGER :: namelen
!  !$         INTEGER(HID_T), INTENT(IN) :: space_id
!  !$       END FUNCTION h5rcreate_region_c
!  !$    END INTERFACE

    f_ptr = C_LOC(ref)

    namelen = LEN(name)
    hdferr = h5rcreate_ptr_c(f_ptr, loc_id, name, namelen, 1, space_id)

!  !$            ref_f = 0
!  !$            hdferr = h5rcreate_region_c(ref_f, loc_id, name, namelen, space_id )
!  !$            ref%ref = ref_f

  END SUBROUTINE h5rcreate_region_f

!****s* H5R (F03)/h5rcreate_ptr_f
!
! NAME
!  h5rcreate_ptr_f
!
! PURPOSE
!  Creates a reference.
!
! Inputs:
!  loc_id     - location identifier
!  name	      - name of the dataset at the specified location
!  ref_type   - type of reference:
!                H5R_OBJECT
!                H5T_STD_REF_DSETREG
! Outputs:
!  ref	      - reference created by the function call.
!  hdferr     - error code
!		   Success:  0
!		   Failure: -1
! OPTIONAL
!  space_id   - dataspace identifier that describes selected region
!
! AUTHOR
!  M. Scot Breitenfeld
!  June 20, 2008
!
! NOTES
!  This is a module procedure for the h5rcreate_f
!  subroutine where the output is a pointer.
!
! Signature:
  SUBROUTINE h5rcreate_ptr_f(loc_id, name, ref_type, ref, hdferr, space_id)
    USE, INTRINSIC :: ISO_C_BINDING
    IMPLICIT NONE
    INTEGER(HID_T), INTENT(IN) :: loc_id     ! Location identifier
    CHARACTER(LEN=*), INTENT(IN) :: name     ! Name of the dataset at location specified
                                             ! by loc_id identifier
    INTEGER, INTENT(IN) :: ref_type          ! type of reference
    TYPE(C_PTR), INTENT(INOUT) :: ref        ! Reference created by the function call
    INTEGER, INTENT(OUT) :: hdferr           ! Error code
    INTEGER(HID_T), INTENT(IN), OPTIONAL :: space_id ! Dataset's dataspace identifier
!*****
    INTEGER :: namelen                       ! Name length
    INTEGER(HID_T) :: space_id_c

    namelen = LEN(name)
    space_id_c = -1
    IF(PRESENT(space_id)) space_id_c =  space_id
    hdferr = h5rcreate_ptr_c(ref, loc_id, name, namelen, ref_type, space_id_c)

  END SUBROUTINE h5rcreate_ptr_f
!****s* H5R (F03)/h5rdereference_object_f
!
! NAME
!  h5rdereference_object_f
!
! PURPOSE
!  Opens the HDF5 object referenced
!
! Inputs:
!  dset_id  - identifier of the dataset containing
!             reference
!  ref 	    - reference to open
! Outputs:
!  obj_id   - object_identifier
!  hdferr:  - error code
!              Success:  0
!              Failure: -1
! AUTHOR
!  Elena Pourmal
!  August 12, 1999
!
! HISTORY
!  Explicit Fortran interfaces were added for
!  called C functions (it is needed for Windows
!  port).  February 28, 2001
!
! NOTES
!  This is a module procedure for the h5rdereference_f subroutine.
!
! Signature:
  SUBROUTINE h5rdereference_object_f(obj_id, ref, ref_obj_id, hdferr)
    USE, INTRINSIC :: ISO_C_BINDING
    IMPLICIT NONE
    INTEGER(HID_T), INTENT(IN) :: obj_id          ! Dataset identifier
    TYPE(hobj_ref_t_f), INTENT(IN), TARGET :: ref ! Object reference
    INTEGER(HID_T), INTENT(OUT) :: ref_obj_id     ! Object identifier
    INTEGER, INTENT(OUT) :: hdferr                ! Error code
!*****
    INTEGER(HADDR_T) :: ref_f          ! Local buffer to pass reference
    TYPE(C_PTR) :: f_ptr

    f_ptr = C_LOC(ref)
    hdferr = h5rdereference_ptr_c(obj_id, 0, f_ptr, ref_obj_id)

  END SUBROUTINE h5rdereference_object_f
!****s* H5R (F03)/h5rdereference_region_f
!
! NAME
!  h5rdereference_region_f
!
! PURPOSE
!  Opens the dataset region
!
! Inputs:
!  dset_id 	 - identifier of the dataset containing
!                  reference to teh regions
!  ref 	         - reference to open
! Outputs:
!  obj_id 	 - dataspace identifier
!  hdferr:	 - error code
!                   Success:  0
!                   Failure: -1
!
! AUTHOR
!  Elena Pourmal
!  August 12, 1999
!
! HISTORY
!  Explicit Fortran interfaces were added for
!  called C functions (it is needed for Windows
!  port).  February 28, 2001
!
! NOTES
!  This is a module procedure for the h5rdereference_f subroutine.
!
! Signature:
  SUBROUTINE h5rdereference_region_f(obj_id, ref, ref_obj_id, hdferr)
    USE, INTRINSIC :: ISO_C_BINDING
    IMPLICIT NONE
    INTEGER(HID_T), INTENT(IN) :: obj_id   ! Dataset identifier
    TYPE(hdset_reg_ref_t_f), INTENT(IN), TARGET :: ref   ! Object reference
    INTEGER(HID_T), INTENT(OUT) :: ref_obj_id  ! Dataspace identifier
    INTEGER, INTENT(OUT) :: hdferr          ! Error code
!*****
    TYPE(C_PTR) :: f_ptr

    f_ptr = C_LOC(ref)
    hdferr = h5rdereference_ptr_c(obj_id, 1, f_ptr, ref_obj_id)

  END SUBROUTINE h5rdereference_region_f

!****s* H5R (F03)/h5rdereference_ptr_f
!
! NAME
!  h5rdereference_ptr_f
!
! PURPOSE
!  Opens the HDF5 object referenced.
!
! Inputs:
!  obj_id     - valid identifier for the file containing the
!               referenced object or any object in that file.
!  ref_type   - the reference type of ref.
!  ref        - Reference to open.
! Outputs:
!  ref_obj_id - identifier of referenced object
!  hdferr     - error code
!		 Success:  0
!		 Failure: -1
! AUTHOR
!  M. Scot Breitenfeld
!  June 20, 2008
!
! NOTES
!  This is a module procedure for the h5rdereference_f
!  subroutine using pointers.
!
! Signature:
  SUBROUTINE h5rdereference_ptr_f(obj_id, ref_type, ref, ref_obj_id, hdferr)
    USE, INTRINSIC :: ISO_C_BINDING
    IMPLICIT NONE
    INTEGER(HID_T), INTENT(IN) :: obj_id  ! Valid identifier for the file containing the
                                          !  referenced object or any object in that file.
    INTEGER, INTENT(IN) :: ref_type       ! The reference type of ref.
    TYPE(C_PTR), INTENT(IN) :: ref        ! Object reference
    INTEGER(HID_T), INTENT(OUT) :: ref_obj_id
                                          ! Identifier of referenced object
    INTEGER, INTENT(OUT) :: hdferr        ! Error code
!***** 
    hdferr = h5rdereference_ptr_c(obj_id, ref_type, ref, ref_obj_id)

  END SUBROUTINE h5rdereference_ptr_f
!
!****s* H5R (F03)/h5rget_name_object_f
!
! NAME
!  h5rget_name_object_f
!
! PURPOSE
!  Retrieves a name of a referenced object.
!
! Inputs:
!  loc_id    - Identifier for the dataset containing the reference or for the group that dataset is in.
!  ref 	     - An object or dataset region reference.
!
! Outputs:
!  name      - A name associated with the referenced object or dataset region.
!
!  hdferr:   - error code
!               Success:  0
!               Failure: -1
!
! Optional parameters:
!  size     - The size of the name buffer.
!
! AUTHOR
!  M. Scot Breitenfeld
!  March 28, 2008
!
! Signature:S
  SUBROUTINE h5rget_name_object_f(loc_id,  ref, name, hdferr, size)
    USE, INTRINSIC :: ISO_C_BINDING
    IMPLICIT NONE
    INTEGER(HID_T), INTENT(IN) :: loc_id   ! Identifier for the dataset containing the reference
                                           ! or for the group that dataset is in.
    TYPE(hobj_ref_t_f), INTENT(IN), TARGET :: ref  ! Object reference
    INTEGER(SIZE_T), OPTIONAL, INTENT(OUT) :: size ! The size of the name buffer,
                                                   ! returning 0 (zero) if no name is associated
                                                   ! with the identifier
    CHARACTER(LEN=*), INTENT(OUT) :: name  ! A name associated with the referenced object or dataset region.
    INTEGER, INTENT(OUT) :: hdferr         ! Error code
!*****
    INTEGER(HADDR_T) :: ref_f              ! Local buffer to pass reference

    INTEGER(SIZE_T) :: size_default
    INTEGER(SIZE_T) :: name_len
    TYPE(C_PTR) :: f_ptr

    f_ptr = C_LOC(ref)

    name_len=LEN(name)

    hdferr = h5rget_name_ptr_c(loc_id, 0, f_ptr, name, name_len, size_default)


    IF(PRESENT(size)) size = size_default

  END SUBROUTINE h5rget_name_object_f
!****s* H5R (F03)/h5rget_name_region_f
!
! NAME
!  h5rget_name_region_f
!
! PURPOSE
!  Retrieves a name of a dataset region.
!
! Inputs:
!  loc_id  - Identifier for the dataset containing the reference or
!            for the group that dataset is in.
!  ref 	   - An object or dataset region reference.
!
! Outputs:
!  name    - A name associated with the referenced object or dataset region.
!  hdferr  - error code
!              Success:  0
!              Failure: -1
!
! Optional parameters:
!  size    - The size of the name buffer.
!
! AUTHOR
!  M. Scot Breitenfeld
!  March 28, 2008
!
! Signature:
  SUBROUTINE h5rget_name_region_f(loc_id, ref, name, hdferr, size)
    USE, INTRINSIC :: ISO_C_BINDING
    IMPLICIT NONE
    INTEGER(HID_T), INTENT(IN) :: loc_id   ! Identifier for the dataset containing the reference
                                           ! or for the group that dataset is in.
    TYPE(hdset_reg_ref_t_f), INTENT(IN), TARGET :: ref ! Object reference
    INTEGER(SIZE_T), OPTIONAL, INTENT(OUT) :: size     ! The size of the name buffer,
                                                       ! returning 0 (zero) if no name is associated with the identifier
    CHARACTER(LEN=*), INTENT(OUT) :: name  ! A name associated with the referenced object or dataset region.
    INTEGER, INTENT(OUT) :: hdferr         ! Error code
!*****
    INTEGER :: ref_f(REF_REG_BUF_LEN)      ! Local buffer to pass reference
    INTEGER(SIZE_T) :: size_default
    INTEGER(SIZE_T) :: name_len
    TYPE(C_PTR) :: f_ptr

    f_ptr = C_LOC(ref)

    name_len=LEN(name)

    hdferr = h5rget_name_ptr_c(loc_id, 1, f_ptr, name, name_len, size_default)

    IF(PRESENT(size)) size = size_default

  END SUBROUTINE h5rget_name_region_f

  !****s* H5R (F03)/h5rget_name_ptr_f
  !
  ! NAME
  !  h5rget_name_ptr_f
  !
  ! PURPOSE
  !  Retrieves a name of a referenced object.
  !
  ! Inputs:
  !  loc_id   - Identifier for the dataset containing the reference or
  !             for the group that dataset is in.
  !  ref_type - Type of reference.
  !  ref      - An object or dataset region reference.
  !
  ! Outputs:
  !  name     - A name associated with the referenced object or dataset ptr.
  !
  !  hdferr   - error code
  !		  Success:  0
  !		  Failure: -1
  !
  ! Optional parameters:
  !   size   - The size of the name buffer.
  !
  ! AUTHOR
  !  M. Scot Breitenfeld
  !  March 28, 2008
  !
  ! Signature:
  SUBROUTINE h5rget_name_ptr_f(loc_id, ref_type, ref, name, hdferr, size)
    USE, INTRINSIC :: ISO_C_BINDING
    IMPLICIT NONE
    INTEGER(HID_T), INTENT(IN) :: loc_id   ! Identifier for the dataset containing the reference
                                           !  or for the group that dataset is in.
    INTEGER, INTENT(IN) :: ref_type ! Type of reference.
    TYPE(C_PTR), INTENT(IN) :: ref  ! An object or dataset region reference.
    CHARACTER(LEN=*), INTENT(OUT) :: name  ! A name associated with the referenced object or dataset ptr.
    INTEGER, INTENT(OUT) :: hdferr         ! Error code
    INTEGER(SIZE_T), OPTIONAL, INTENT(OUT) :: size   ! The size of the name buffer,
                                                     ! returning 0 (zero) if no name is associated
                                                     ! with the identifier
!*****
    INTEGER(SIZE_T) :: size_default
    INTEGER(SIZE_T) :: name_len

    name_len=LEN(name)

    hdferr = h5rget_name_ptr_c(loc_id, ref_type, ref, name, name_len, size_default)

    IF(PRESENT(size)) size = size_default

  END SUBROUTINE h5rget_name_ptr_f

  !****s* H5R (F03)/h5rget_obj_type_f
  !
  ! NAME
  !  h5rget_obj_type_f
  !
  ! PURPOSE
  !  Retrieves the type of object that an object reference points to.
  !
  ! Inputs:
  !  loc_id   - Identifier for the dataset containing the reference or
  !             for the group that dataset is in.
  !  ref_type - Type of reference to query.
  !  ref      - Reference to query.
  !
  ! Outputs:
  !  obj_type - Type of referenced object. 
  !               H5G_UNKNOWN_F (-1)
  !               H5G_LINK_F      0
  !               H5G_GROUP_F     1
  !               H5G_DATASET_F   2
  !               H5G_TYPE_F      3
  !              
  !  hdferr   - error code
  !		  Success:  0
  !		  Failure: -1
  !
  ! AUTHOR
  !  M. Scot Breitenfeld
  !  Decemeber 17, 2008
  !
  ! Signature:
  SUBROUTINE h5rget_obj_type_f(loc_id, ref_type, ref, obj_type, hdferr)
    USE, INTRINSIC :: ISO_C_BINDING
    IMPLICIT NONE
    INTEGER(HID_T), INTENT(IN) :: loc_id
    INTEGER, INTENT(IN) :: ref_type
    TYPE(C_PTR), INTENT(IN) :: ref
    INTEGER, INTENT(OUT) :: obj_type
    INTEGER, INTENT(OUT) :: hdferr
    !*****

    INTERFACE
       INTEGER FUNCTION h5rget_obj_type_c(loc_id, ref_type, ref, obj_type)
         USE, INTRINSIC :: ISO_C_BINDING
         USE H5GLOBAL
         !DEC$IF DEFINED(HDF5F90_WINDOWS)
         !DEC$ATTRIBUTES C,reference,decorate,alias:'H5RGET_OBJ_TYPE_C':: h5rget_obj_type_c
         !DEC$ENDIF
         INTEGER(HID_T), INTENT(IN) :: loc_id
         INTEGER, INTENT(IN) :: ref_type
         TYPE(C_PTR), VALUE :: ref
         INTEGER :: obj_type
       END FUNCTION h5rget_obj_type_c
    END INTERFACE

    hdferr = h5rget_obj_type_c(loc_id, ref_type, ref, obj_type)

  END SUBROUTINE h5rget_obj_type_f

END MODULE H5R_PROVISIONAL
