/*
  Warnings:

  - The primary key for the `Product` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `article` on the `Product` table. All the data in the column will be lost.
  - You are about to drop the column `min_cost_for_partner` on the `Product` table. All the data in the column will be lost.
  - You are about to drop the column `name` on the `Product` table. All the data in the column will be lost.
  - You are about to drop the column `product_type_id` on the `Product` table. All the data in the column will be lost.
  - You are about to drop the `Material` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `MaterialHistory` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `MaterialType` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Partner` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `PartnerType` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `ProductMaterial` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `ProductType` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Sale` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Supplier` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `SupplierType` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `UnitMeasurement` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `cost` to the `Product` table without a default value. This is not possible if the table is not empty.
  - Added the required column `isActive` to the `Product` table without a default value. This is not possible if the table is not empty.
  - Added the required column `manufacturerId` to the `Product` table without a default value. This is not possible if the table is not empty.
  - Added the required column `title` to the `Product` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "Material" DROP CONSTRAINT "Material_material_type_id_fkey";

-- DropForeignKey
ALTER TABLE "Material" DROP CONSTRAINT "Material_unit_measurement_id_fkey";

-- DropForeignKey
ALTER TABLE "MaterialHistory" DROP CONSTRAINT "MaterialHistory_material_id_fkey";

-- DropForeignKey
ALTER TABLE "MaterialHistory" DROP CONSTRAINT "MaterialHistory_supplier_id_fkey";

-- DropForeignKey
ALTER TABLE "Partner" DROP CONSTRAINT "Partner_partner_type_id_fkey";

-- DropForeignKey
ALTER TABLE "Product" DROP CONSTRAINT "Product_product_type_id_fkey";

-- DropForeignKey
ALTER TABLE "ProductMaterial" DROP CONSTRAINT "ProductMaterial_material_id_fkey";

-- DropForeignKey
ALTER TABLE "ProductMaterial" DROP CONSTRAINT "ProductMaterial_product_id_fkey";

-- DropForeignKey
ALTER TABLE "Sale" DROP CONSTRAINT "Sale_partner_id_fkey";

-- DropForeignKey
ALTER TABLE "Sale" DROP CONSTRAINT "Sale_product_id_fkey";

-- DropForeignKey
ALTER TABLE "Supplier" DROP CONSTRAINT "Supplier_supplier_type_id_fkey";

-- AlterTable
ALTER TABLE "Product" DROP CONSTRAINT "Product_pkey",
DROP COLUMN "article",
DROP COLUMN "min_cost_for_partner",
DROP COLUMN "name",
DROP COLUMN "product_type_id",
ADD COLUMN     "cost" DOUBLE PRECISION NOT NULL,
ADD COLUMN     "description" TEXT,
ADD COLUMN     "id" SERIAL NOT NULL,
ADD COLUMN     "isActive" BOOLEAN NOT NULL,
ADD COLUMN     "mainImagePath" TEXT,
ADD COLUMN     "manufacturerId" INTEGER NOT NULL,
ADD COLUMN     "title" TEXT NOT NULL,
ADD CONSTRAINT "Product_pkey" PRIMARY KEY ("id");

-- DropTable
DROP TABLE "Material";

-- DropTable
DROP TABLE "MaterialHistory";

-- DropTable
DROP TABLE "MaterialType";

-- DropTable
DROP TABLE "Partner";

-- DropTable
DROP TABLE "PartnerType";

-- DropTable
DROP TABLE "ProductMaterial";

-- DropTable
DROP TABLE "ProductType";

-- DropTable
DROP TABLE "Sale";

-- DropTable
DROP TABLE "Supplier";

-- DropTable
DROP TABLE "SupplierType";

-- DropTable
DROP TABLE "UnitMeasurement";

-- CreateTable
CREATE TABLE "Tag" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "color" TEXT NOT NULL,

    CONSTRAINT "Tag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Gender" (
    "code" SERIAL NOT NULL,
    "name" TEXT,

    CONSTRAINT "Gender_pkey" PRIMARY KEY ("code")
);

-- CreateTable
CREATE TABLE "Client" (
    "id" SERIAL NOT NULL,
    "firstName" TEXT NOT NULL,
    "lastName" TEXT NOT NULL,
    "patronymic" TEXT,
    "birthday" TIMESTAMP(3),
    "registrationDate" TIMESTAMP(3) NOT NULL,
    "email" TEXT,
    "phone" TEXT NOT NULL,
    "genderCode" INTEGER,
    "photoPath" TEXT,

    CONSTRAINT "Client_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TagOfClient" (
    "clientId" INTEGER NOT NULL,
    "tagId" INTEGER NOT NULL,

    CONSTRAINT "TagOfClient_pkey" PRIMARY KEY ("clientId","tagId")
);

-- CreateTable
CREATE TABLE "Service" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "cost" DOUBLE PRECISION NOT NULL,
    "durationInSeconds" INTEGER NOT NULL,
    "description" TEXT,
    "discount" DOUBLE PRECISION,
    "mainImagePath" TEXT,

    CONSTRAINT "Service_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ServicePhoto" (
    "id" SERIAL NOT NULL,
    "serviceID" INTEGER NOT NULL,
    "photoPath" TEXT NOT NULL,

    CONSTRAINT "ServicePhoto_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Manufacturer" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "startDate" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Manufacturer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProductPhoto" (
    "id" SERIAL NOT NULL,
    "productId" INTEGER NOT NULL,
    "photoPath" TEXT NOT NULL,

    CONSTRAINT "ProductPhoto_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AttachedProduct" (
    "mainProductId" INTEGER NOT NULL,
    "attachedProductId" INTEGER NOT NULL,

    CONSTRAINT "AttachedProduct_pkey" PRIMARY KEY ("mainProductId","attachedProductId")
);

-- CreateTable
CREATE TABLE "ClientService" (
    "id" SERIAL NOT NULL,
    "clientId" INTEGER NOT NULL,
    "serviceId" INTEGER NOT NULL,
    "startTime" TIMESTAMP(3) NOT NULL,
    "comment" TEXT,

    CONSTRAINT "ClientService_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DocumentByService" (
    "id" SERIAL NOT NULL,
    "clientServiceId" INTEGER NOT NULL,
    "documentPath" TEXT NOT NULL,

    CONSTRAINT "DocumentByService_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProductSale" (
    "id" SERIAL NOT NULL,
    "saleDate" TIMESTAMP(3) NOT NULL,
    "productId" INTEGER NOT NULL,
    "quantity" INTEGER NOT NULL,
    "clientServiceId" INTEGER NOT NULL,

    CONSTRAINT "ProductSale_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Tag_title_key" ON "Tag"("title");

-- AddForeignKey
ALTER TABLE "Client" ADD CONSTRAINT "Client_genderCode_fkey" FOREIGN KEY ("genderCode") REFERENCES "Gender"("code") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TagOfClient" ADD CONSTRAINT "TagOfClient_clientId_fkey" FOREIGN KEY ("clientId") REFERENCES "Client"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TagOfClient" ADD CONSTRAINT "TagOfClient_tagId_fkey" FOREIGN KEY ("tagId") REFERENCES "Tag"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ServicePhoto" ADD CONSTRAINT "ServicePhoto_serviceID_fkey" FOREIGN KEY ("serviceID") REFERENCES "Service"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Product" ADD CONSTRAINT "Product_manufacturerId_fkey" FOREIGN KEY ("manufacturerId") REFERENCES "Manufacturer"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProductPhoto" ADD CONSTRAINT "ProductPhoto_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AttachedProduct" ADD CONSTRAINT "AttachedProduct_mainProductId_fkey" FOREIGN KEY ("mainProductId") REFERENCES "Product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AttachedProduct" ADD CONSTRAINT "AttachedProduct_attachedProductId_fkey" FOREIGN KEY ("attachedProductId") REFERENCES "Product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ClientService" ADD CONSTRAINT "ClientService_clientId_fkey" FOREIGN KEY ("clientId") REFERENCES "Client"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ClientService" ADD CONSTRAINT "ClientService_serviceId_fkey" FOREIGN KEY ("serviceId") REFERENCES "Service"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DocumentByService" ADD CONSTRAINT "DocumentByService_clientServiceId_fkey" FOREIGN KEY ("clientServiceId") REFERENCES "ClientService"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProductSale" ADD CONSTRAINT "ProductSale_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProductSale" ADD CONSTRAINT "ProductSale_clientServiceId_fkey" FOREIGN KEY ("clientServiceId") REFERENCES "ClientService"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
