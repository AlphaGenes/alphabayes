!##################################################################################################################################

subroutine ReadData
use Global
implicit none

integer :: i,j
character(len=100) :: dumC
real (4) :: ave,adev,sdev,var,skew,curt,TmpAlleleFreq,Tmp2pq,sum2pq

open (unit=101,file=trim(GenoTrFile),status="old")
open (unit=102,file=trim(PhenoTrFile),status="old")
open (unit=103,file=trim(GenoTeFile),status="old")
open (unit=104,file=trim(TbvFile),status="old")
open (unit=105,file="AlleleFreq.txt",status="unknown")

allocate(SnpTmp(nSnpExternal))
allocate(GenosTr(nAnisTr,nSnp))
allocate(GenosTe(nAnisTe,nSnp))
allocate(Phen(nAnisTr,1))
allocate(E(nAnisTr,1))
allocate(G(nSnp,1))
allocate(Tbv(nAnisTe,1))
allocate(Ebv(nAnisTe,1))

allocate(SnpPosition(nSnp))
j=0
do i=1,nSnpExternal
	if (FixedSnp(i)==1) then
		j=j+1
		SnpPosition(j)=i
	endif
enddo	

do i=1,nAnisTr
	read (101,*) dumC,SnpTmp(:)
	GenosTr(i,:)=SnpTmp(SnpPosition(:))
	read (102,*) dumC,Phen(i,1)
enddo	

call momentR4(Phen(:,1),nAnisTr,ave,adev,sdev,var,skew,curt)

Phen(:,1)=(Phen(:,1)-ave)/sdev

do i=1,nAnisTe
	read (103,*) dumC,SnpTmp(:)
	GenosTe(i,:)=SnpTmp(SnpPosition(:))
	read (104,*) dumC,Tbv(i,1)
enddo

sum2pq=0.0
do j=1,nSnp
	call momentR4(GenosTr(:,j),nAnisTr,ave,adev,sdev,var,skew,curt)
	TmpAlleleFreq=ave/2.d0
	Tmp2pq=2.d0*(1.d0-TmpAlleleFreq)*TmpAlleleFreq+0.00001
	sum2pq=sum2pq+Tmp2pq
	if(ScalingOpt==1) then
	  ! Scaling markers by marker specific genotypic variance
		Tmp2pq=sqrt(Tmp2pq)
	  GenosTr(:,j)=(GenosTr(:,j)-ave)/Tmp2pq
	  GenosTe(:,j)=(GenosTe(:,j)-ave)/Tmp2pq
	endif
enddo
if(ScalingOpt==2) then
  ! Scaling markers by global genotypic variance
  GenosTr(:,:)=GenosTr(:,:)/sqrt(sum2pq/nSnp)
  GenosTe(:,:)=GenosTe(:,:)/sqrt(sum2pq/nSnp)
endif

end subroutine ReadData

!###########################################################################################################################################################
