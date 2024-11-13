const express = require('express')
const cors = require('cors')
const app = express()
const port = process.env.PORT || 3000

app.use(cors()) // было app.use(express.json)
app.use(express.json())

const { PrismaClient } = require('@prisma/client')
const prisma = new PrismaClient()

app.get('/', (req, res) => {
    res.json({ message: 'Сервер запущен' })
})

app.get('/get-all-products', async (req, res) => {
    const searchQuery = req.query.q;

    if (!searchQuery) {
        const allProducts = await prisma.product.findMany({
            select: {
                id: true,
                title: true,
                cost: true,
                description: true,
                mainImagePath: true,
                isActive: true,
                Manufacturer: true
            },
        })
    
        res.json({
            data: allProducts,
            meta: {count: allProducts.count}
        })
      }
    else {
        const allProducts = await prisma.product.findMany({
            where: {
                OR: [
                    {title: searchQuery},
                    {description: searchQuery}
                ]
                
            }
        })
    
        res.json({
            data: allProducts,
            meta: {count: allProducts.count}
        })
    }
})

app.get('/get-all-manufacturers', async (req, res) => {
    const allManufacturers = await prisma.manufacturer.findMany()
    res.json({
        data: allManufacturers,
    })
})

app.get('/get-all-productsale', async (req, res) => {
  const allProductSales = await prisma.productSale.findMany({
      select: {
          id: true,
          saleDate: true,
          quantity: true,
          productId: true
      }
  })
  res.json({
      data: allProductSales,
      meta: {}
  })
})


app.post('/post-product', async (req, res) => {
    const { title, cost, description, isActive, manufacturerId } = req.body;
  
    const numericCost = parseFloat(cost);
    const booleanIsActive = isActive === '1';
    const numericManufacturerId = parseInt(manufacturerId, 10);
  
    console.log('Полученные данные:', { title, cost: numericCost, description, isActive: booleanIsActive, manufacturerId: numericManufacturerId });
  
    try {
      const manufacturerExists = await prisma.manufacturer.findUnique({
        where: { id: numericManufacturerId },
      });
  
      if (!manufacturerExists) {
        return res.status(400).json({ error: 'Производитель не найден' });
      }
  
      const product = await prisma.product.create({
        data: {
          title,
          cost: numericCost,
          description,
          isActive: booleanIsActive,
          manufacturerId: numericManufacturerId,

        },
      });
  
      res.json(product);
    } catch (error) {
      console.error('Ошибка создания продукта', error);
  
      if (error.code === 'P2002') {
        return res.status(400).json({ error: 'P2002' });
      }
  
      res.status(500).json({ error: 'я хз что за ошибка, читай сам', details: error });
    }
  });

app.put('/put-product', async(req, res) => {
  const { id, title, cost, description, isActive, manufacturerId } = req.body;

  const numericId = parseInt(id)
  const numericCost = parseFloat(cost);
  const booleanIsActive = isActive === '1';
  const numericManufacturerId = parseInt(manufacturerId, 10);

  console.log('Полученные данные:', { id: numericId, title, cost: numericCost, description, isActive: booleanIsActive, manufacturerId: numericManufacturerId });

  const product = await prisma.product.update({
    data: {
      title,
      cost: numericCost,
      description,
      isActive: booleanIsActive,
      manufacturerId: numericManufacturerId,

    },
    where: {
      id: numericId
    }
  });

  res.json(product);

})

app.delete('/delete-product', async (req, res) => {
  try {
    const { id } = req.body;
    const numericId = parseInt(id);

    const deleteProductHistory = prisma.productSale.deleteMany({
      where: {
        productId: numericId,
      }
    });

    const deleteProduct = prisma.product.delete({
      where: {
        id: numericId
      }
    });

    const result = await prisma.$transaction([deleteProductHistory, deleteProduct]);
    
    console.log(result);
    return res.json(result);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'Произошла ошибка при удалении продукта' });
  }
});
app.listen(port, () => {
    console.log(`API прослушивается на порте - ${port}`)
})