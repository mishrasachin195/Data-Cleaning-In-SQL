/*

CLEANING DATA IN SQL QUERIES

*/

Select *
From PortfolioProject..NashvilleHousing;


--STANDARDIZE DATE FORMAT

Select SaleDate, Convert(Date,SaleDate)
From PortfolioProject..NashvilleHousing;


Update NashvilleHousing
Set SaleDate=Convert(Date,SaleDate);


Alter Table NashvilleHousing
ADD SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted=Convert(Date,SaleDate);


--POPULATE PROPERTY ADDRESS DATA

Select*
From PortfolioProject..NashvilleHousing
order by ParcelId;


Select a.ParcelId,a.PropertyAddress,b.ParcelId,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
on a.ParcelId=b.ParcelId
AND a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is NULL;


Update a
SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
on a.ParcelId=b.ParcelId
AND a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is NULL;

 --BREAKING THE PROPERTYADDRESS IN THE INDIVIDUAL COLUMN(Address,City,State)

 Select*
From PortfolioProject..NashvilleHousing
order by ParcelId;


Select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) As Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))
 as Address from PortfolioProject..NashvilleHousing;


Alter Table PortfolioProject.. NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

Update PortfolioProject..NashvilleHousing
Set PropertySplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1);

Alter Table PortfolioProject..NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

Update PortfolioProject..NashvilleHousing
Set PropertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress));


Select *
From PortfolioProject..NashvilleHousing;


Select OwnerAddress
From PortfolioProject..NashvilleHousing;

Select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From PortfolioProject..NashvilleHousing;


Alter Table PortfolioProject.. NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

Update PortfolioProject..NashvilleHousing
Set OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),3);

Alter Table PortfolioProject..NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

Update PortfolioProject..NashvilleHousing
Set OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2);


Alter Table PortfolioProject.. NashvilleHousing
ADD OwnerSplitState Nvarchar(255);

Update PortfolioProject..NashvilleHousing
Set OwnerSplitState=PARSENAME(REPLACE(OwnerAddress,',','.'),1);



Select *
From PortfolioProject..NashvilleHousing;


--CHANGE Y AND N TO YES AND NO IN SOLDASVACANT FIELD


Select Distinct(SoldAsVacant),Count(SoldAsVacant)
From PortfolioProject..NashvilleHousing
Group by SoldAsVacant
Order by 2;


Select SoldAsVacant,
CASE When SoldAsVacant='Y' Then 'Yes'
     When SoldAsVacant='N' Then 'No'
	 Else SoldAsVacant
	 END
From PortfolioProject..NashvilleHousing



Update PortfolioProject..NashvilleHousing
SET SoldAsVacant=CASE When SoldAsVacant='Y' Then 'Yes'
     When SoldAsVacant='N' Then 'No'
	 Else SoldAsVacant
	 END



--REMOVE DUPLICATES



With RowNumCTE as
(Select*,
ROW_NUMBER() Over(Partition by ParcelID,
                               PropertyAddress,
							   SalePrice,
							   SaleDate,
							   LegalReference
							   Order by UniqueID) row_num
From PortfolioProject..NashvilleHousing
--Order by ParcelID
)
DELETE
from RowNumCTE
Where row_num>1
--Order by PropertyAddress;



--DELETE UNUSED COLUMNS


Select *
From PortfolioProject..NashvilleHousing;

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN PropertyAddress,OwnerAddress,TaxDistrict;

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN SaleDate;
