      subroutine sym_w_mi(iq,ig,w)
      use atom_mod
      use solid_mod
      use units_mod
      implicit none
      integer, intent(in) :: iq,ig
      complex*16, intent(inout) :: w(n_pbmt,nplw_gw)
      integer :: iq0,j,iatom,isort,i0,i,j0,igtild,j1,gbs_number
      double precision :: pi2,fas,v(3)
      complex*16 :: cf
      complex*16, allocatable :: w_0(:,:)
      allocate(w_0(n_pbmt,nplw_gw))
      w_0=w
      pi2=pi+pi
      iq0=ip_k(iq,ig)
      igtild=g_sym_0(iq,ig)
      do j=1,nplwgw(iq0)
        j0=indpw_gw(j,iq)       !! G' in GBS-list
        v=gbs(:,j0)+gbs(:,igtild) !! G'+G_A
        j1=gbs_number(v)        !! G'+G_A in GBS-list
        j1=gbs_sym(j1,ig)       !! A^(-1)*(G'+G_A) in GBS-list
        j1=iplf_gk(j1,iq0)
        w(:,j)=w_0(:,j1)
        call sym_w_left(ip(1,ig),u(1,ig),w(1,j),1)
        do iatom=1,natom
          isort=is(iatom)
          i0=iopb(iatom)
          i=i0+n_pbmt0(isort)-1
          fas=pi2*dot_product(pnt(:,iq),tshift(:,iatom,ig))
          cf=dcmplx(cos(fas),sin(fas))
          w(i0:i,j)=cf*w(i0:i,j)
        enddo
        if(.not.symmorph) then
          fas=pi2*dot_product(pnt(:,iq)+gbs(:,j0),shift(:,ig))
          cf=dcmplx(cos(fas),sin(fas))
          call zscal(n_pbmt,cf,w(1,j),1)
        endif
        if(ifia(ig).eq.-1) then
          do i=1,n_pbmt
            w(i,j)=conjg(w(i,j))
          enddo
        endif
      enddo                     !! over j
      deallocate(w_0)
      end
