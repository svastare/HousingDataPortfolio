
--Display The Table
Select * from PortfolioProject.dbo.NashvilleHousing


-- Standardize Date Format 

Select SaleDate, CONVERT(Date,SaleDate)
from PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NASHVILLEHOUSING
ADD SaleDateConverted Date;

Update NashvilleHousing 
SET SaleDateConverted = CONVERT(Date,SaleDate)


-- Property Address data

Select *
from PortfolioProject..NashvilleHousing
--where PropertyAddress is null
order by ParcelID


--POPULATE NULL ADDRESS WITH PROPER ADDRESS WHERE SAME PARCELID 
Select *
from PortfolioProject..NashvilleHousing A 
JOIN PortfolioProject..NashvilleHousing B
ON A.ParcelID = B.ParcelID



Select A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress,B.PropertyAddress)
from PortfolioProject..NashvilleHousing A 
JOIN PortfolioProject..NashvilleHousing B
	ON A.ParcelID = B.ParcelID
	AND A.[UniqueID ]  <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL


-- run this update and then run the above Query to check for no null 
Update a
SET PropertyAddress  = ISNULL(A.PropertyAddress,B.PropertyAddress) 
from PortfolioProject..NashvilleHousing A 
JOIN PortfolioProject..NashvilleHousing B
	ON A.ParcelID = B.ParcelID
	AND A.[UniqueID ]  <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL


-- Breaking out Address into Individual Columns - Address, City, State

Select PropertyAddress from 
PortfolioProject..NashvilleHousing


-- Using DELIMITER IMPORTANT--

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address

from PortfolioProject..NashvilleHousing

-- Add SPLIT ADDRESS AND SPLIT CITY INTO THE TABLE

ALTER TABLE NASHVILLEHOUSING
ADD PropertySplitAddress Nvarchar(255);

Update NashvilleHousing 
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NASHVILLEHOUSING
ADD PropertySplitCity Nvarchar(255);

Update NashvilleHousing 
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))


Select * From PortfolioProject..NashvilleHousing


Select OwnerAddress
From PortfolioProject..NashvilleHousing



-- PARSENAME usage  -- easier than SUBSTRING

Select 
PARSENAME(REPLACE(OwnerAddress,',','.'), 3)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 2)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
From PortfolioProject..NashvilleHousing


ALTER TABLE NASHVILLEHOUSING
ADD OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing 
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

ALTER TABLE NASHVILLEHOUSING
ADD OwnerSplitCity Nvarchar(255);

Update NashvilleHousing 
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

ALTER TABLE NASHVILLEHOUSING
ADD OwnerSplitState Nvarchar(255);

Update NashvilleHousing 
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)

Select * From PortfolioProject..NashvilleHousing


-- CHANGE Y AND N TO YES AND NO IN 'SOLD AS VACANT' FIELD

Select Distinct(SoldasVacant), Count(SoldasVacant)
from PortfolioProject..NashvilleHousing
group by SoldAsVacant
order by 2 


Select SoldasVacant
, CASE when SoldAsVacant = 'Y' THEN 'YES'
	   when SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
from PortfolioProject..NashvilleHousing


--UPDATE THE TABLE OF Y AND N TO YES AND NO
Update NashvilleHousing
SET SoldasVacant  = CASE when SoldAsVacant = 'Y' THEN 'YES'
	   when SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END



-- REMOVE DUPLICATES USING CTEs
WITH RowNumCTE AS(
Select * ,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

from PortfolioProject..NashvilleHousing
--order by ParcelID
)
DELETE
From RowNumCTE
Where row_num > 1 
--order by PropertyAddress




WITH RowNumCTE AS(
Select * ,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

from PortfolioProject..NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1 
order by PropertyAddress


-- DELETE UNUSED COLUMNS

Select * 
From PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN SaleDate



--DISPLAY CLEANED DATA

Select * 
From PortfolioProject..NashvilleHousing
