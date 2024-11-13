-- CreateTable
CREATE TABLE "ProductType" (
    "id" SERIAL NOT NULL,
    "product_type" VARCHAR(100) NOT NULL,
    "coefficient_of_product_type" DOUBLE PRECISION NOT NULL,

    CONSTRAINT "ProductType_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Product" (
    "article" VARCHAR(7) NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "min_cost_for_partner" DECIMAL(10,2) NOT NULL,
    "product_type_id" INTEGER NOT NULL,

    CONSTRAINT "Product_pkey" PRIMARY KEY ("article")
);

-- CreateTable
CREATE TABLE "PartnerType" (
    "id" SERIAL NOT NULL,
    "partner_type" VARCHAR(100) NOT NULL,

    CONSTRAINT "PartnerType_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Partner" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "director" VARCHAR(100) NOT NULL,
    "email" VARCHAR(100) NOT NULL,
    "phone" VARCHAR(20) NOT NULL,
    "legal_address" VARCHAR(100) NOT NULL,
    "INN" VARCHAR(10) NOT NULL,
    "Rating" INTEGER,
    "partner_type_id" INTEGER NOT NULL,

    CONSTRAINT "Partner_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProductMaterial" (
    "product_id" TEXT NOT NULL,
    "material_id" INTEGER NOT NULL,
    "quantity_material" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "ProductMaterial_pkey" PRIMARY KEY ("product_id","material_id")
);

-- CreateTable
CREATE TABLE "Sale" (
    "product_id" TEXT NOT NULL,
    "partner_id" INTEGER NOT NULL,
    "quantity_products" INTEGER NOT NULL DEFAULT 0,
    "date_sale" DATE NOT NULL,

    CONSTRAINT "Sale_pkey" PRIMARY KEY ("product_id","partner_id")
);

-- CreateTable
CREATE TABLE "SupplierType" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,

    CONSTRAINT "SupplierType_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UnitMeasurement" (
    "id" SERIAL NOT NULL,
    "unit_measurement" VARCHAR(100) NOT NULL,

    CONSTRAINT "UnitMeasurement_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Supplier" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "INN" VARCHAR(10) NOT NULL,
    "supplier_type_id" INTEGER NOT NULL,

    CONSTRAINT "Supplier_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Material" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "quantity_package" INTEGER NOT NULL,
    "description" VARCHAR(100) NOT NULL,
    "image" BYTEA,
    "cost" DECIMAL(10,2) NOT NULL,
    "quantity_stock" INTEGER NOT NULL,
    "minimum_allowable_quantity" INTEGER NOT NULL,
    "unit_measurement_id" INTEGER NOT NULL,
    "material_type_id" INTEGER NOT NULL,

    CONSTRAINT "Material_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MaterialHistory" (
    "id" SERIAL NOT NULL,
    "material_id" INTEGER NOT NULL,
    "value" INTEGER NOT NULL DEFAULT 0,
    "change_date" DATE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "supplier_id" INTEGER NOT NULL,

    CONSTRAINT "MaterialHistory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MaterialType" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "percentage_defective_material" DOUBLE PRECISION NOT NULL,

    CONSTRAINT "MaterialType_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Product" ADD CONSTRAINT "Product_product_type_id_fkey" FOREIGN KEY ("product_type_id") REFERENCES "ProductType"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Partner" ADD CONSTRAINT "Partner_partner_type_id_fkey" FOREIGN KEY ("partner_type_id") REFERENCES "PartnerType"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProductMaterial" ADD CONSTRAINT "ProductMaterial_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "Product"("article") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProductMaterial" ADD CONSTRAINT "ProductMaterial_material_id_fkey" FOREIGN KEY ("material_id") REFERENCES "Material"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Sale" ADD CONSTRAINT "Sale_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "Product"("article") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Sale" ADD CONSTRAINT "Sale_partner_id_fkey" FOREIGN KEY ("partner_id") REFERENCES "Partner"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Supplier" ADD CONSTRAINT "Supplier_supplier_type_id_fkey" FOREIGN KEY ("supplier_type_id") REFERENCES "SupplierType"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Material" ADD CONSTRAINT "Material_unit_measurement_id_fkey" FOREIGN KEY ("unit_measurement_id") REFERENCES "UnitMeasurement"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Material" ADD CONSTRAINT "Material_material_type_id_fkey" FOREIGN KEY ("material_type_id") REFERENCES "MaterialType"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialHistory" ADD CONSTRAINT "MaterialHistory_material_id_fkey" FOREIGN KEY ("material_id") REFERENCES "Material"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialHistory" ADD CONSTRAINT "MaterialHistory_supplier_id_fkey" FOREIGN KEY ("supplier_id") REFERENCES "Supplier"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
