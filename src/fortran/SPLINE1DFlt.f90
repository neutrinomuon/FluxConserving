! ###########################################################################
!     RESUME : Spline1DArr subroutine is written in fortran 2003            !
!              standard. It takes an array of values x to                   !
!              interpolate from the arrays t and y.                         !
!                                                                           !
!     INPUT  : 01) n -> # of array elements in vector t and y               !
!              02) t -> x vector (abcissas)                                 !
!              03) y -> y vector (ordenadas)                                !
!              04) x -> Interpolate into x array                            !
!              05) m -> # of array elements in vector x and o               !
!              06) e -> epsilon machine dependent error                     !
!              07) k -> Print & Check screen (OLD fortran way)              !
!                                                                           !
!     OUTPUT : 01) o -> Interpolated y array                                !
!                                                                           !
!     PYTHON : Python compatibility using f2py revised. Better usage        !
!              with numpy.                                                  !
!                                                                           !
!     Written: Jean Michel Gomes                                            !
!     Checked: Tue May  1 16:09:13 WEST 2012                                !
!              Fri Dec 28 14:55:10 WET  2012                                !
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
SUBROUTINE SPLINE1DFlt( x,o,t,y,n,e,k )

    use ModDataType

    implicit none
    integer  (kind=IB), intent(in) :: n
    integer  (kind=IB), optional :: k
    integer  (kind=IB) :: i,IsShowOn
    real     (kind=RP), intent(in), dimension(0:n-1)  :: t,y

    real     (kind=RP), intent(in)  :: x
    real     (kind=RP), intent(out) :: o
    
    real     (kind=RP), optional :: e

    real     (kind=RP) :: diff, epsilon
    character (len=CH) :: w,z,r

    !f2py real     (kind=RP), intent(in) :: t,y
    !f2py                     intent(hide), depend(t) :: n=shape(t,0)
    !f2py                     intent(hide), depend(y) :: n=shape(y,0)

    !f2py real     (kind=RP), intent(in)  :: x
    !f2py                     intent(out) :: o

    !f2py real     (kind=RP), intent(in), optional :: e=1.0e-8
    
    !f2py                     intent(in), optional :: k=0
    
    intrinsic adjustl, count, present, trim

    if ( present(k) ) then
        IsShowOn = k
    else
        IsShowOn = 0_IB
    end if

    if ( present(e) ) then
       if ( e > 0.0_RP ) then
          epsilon = e
       else
          epsilon = 1.0e-8_RP
       end if
    else
       epsilon = 1.0e-8_RP
    end if

    if ( count(t(0:n-1) >= x - epsilon) == 0_IB ) then
       if ( IsShowOn == 1_IB ) then
          write (*,'(4x,a)') '[PROBLEMATIC] @@@@@@@@@@@@@@@@@@@@@@@@'
          write (*,'(4x,a)') '[SPLINE1DFor] Out of allowed range @@@'
          write (*,'(4x,a)') '[SPLINE1DFor] SPLINE1DFor set = 0.0 @@'
          write (w,'(e15.6)') x
          write (r,'(e15.6)') t(0)
          write (z,'(e15.6)') t(n-1)
          write (*,'(4x,a,a6,a,a6,a,a6)') '[SPLINE1DFor] ',trim(adjustl(w)),' => ',trim(adjustl(r)),' -- ',trim(adjustl(z))
       end if
    else if ( count(t(0:n-1) <= x + epsilon) == 0_IB ) then
       if ( IsShowOn == 1_IB ) then
          write (*,'(4x,a)') '[PROBLEMATIC] @@@@@@@@@@@@@@@@@@@@@@@@'
          write (*,'(4x,a)') '[SPLINE1DFor] Out of allowed range @@@'
          write (*,'(4x,a)') '[SPLINE1DFor] SPLINE1DFor set = 0.0 @@'
          write (w,'(e15.6)') x
          write (r,'(e15.6)') t(0)
          write (z,'(e15.6)') t(n-1)
          write (*,'(4x,a,a6,a,a6,a,a6)') '[SPLINE1DFor] ',trim(adjustl(w)),' => ',trim(adjustl(r)),' -- ',trim(adjustl(z))
       end if
    end if
    
    do i=n-1,0,-1
       diff = x - t(i)
       if (diff >= 0.0_RP) exit
    end do
    
    if ( i > n-2 ) then
       i = n-2
    end if
    if ( i < 0 ) then
       i = 0
    end if
    o = y(i) + (x - t(i))*(y(i+1) - y(i))/(t(i+1) - t(i))

    if ( IsShowOn == 1_IB ) then
       write (*,'(4x,a)') '[SPLINE1DFlt]'
       write (w,'(e15.8)') x
       write (z,'(e15.8)') o
       write (*,'(4x,a,a,a)') '... x: ',trim(adjustl(w))//' ==> y: ', &
            trim(adjustl(z))
       write (*,'(4x,a)') '[SPLINE1DFlt]'
    end if
    
    return
END SUBROUTINE SPLINE1DFlt
! ###########################################################################

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
SUBROUTINE author_SPLINE1Darr( a )
  use ModDataType

  implicit none
  
  character (len=21), intent(out) :: a

  !f2py intent(out) :: a

  a = 'Written by Jean Gomes'
  
END SUBROUTINE author_SPLINE1Darr
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

! Jean@Porto - Tue Sep 27 18:38:40 AZOST 2011 +++++++++++++++++++++++++++++++

! *** Test ******************************************************************
!PROGRAM GeneralTest
!END PROGRAM GeneralTest
! *** Test ******************************************************************
  
! *** Number : 001                                                          !
