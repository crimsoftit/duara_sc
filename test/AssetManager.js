const { assert } = require('chai')

const AssetManager = artifacts.require("AssetManager")

require('chai')
	.use(require('chai-as-promised'))
	.should()

contract ('AssetManager', function (accounts) {
    let assetmanager

    before (async () => {
        assetmanager = await AssetManager.deployed()
    })

    describe ('deployement', async () => {
        it ('deploys successfully', async () => {
            const address = await assetmanager.address;
            assert.notEqual (address, 0x0)
            assert.notEqual (address, '')
            assert.notEqual (address, null)
            assert.notEqual (address, undefined)
        })
    })

    describe ('create asset', async () => {
        let result, tAssets

        before (async () => {
            result = await assetmanager.createAsset('viki', 'barcodestring')
            tAssets = await assetmanager.assetCount()
        })

        it ('counts well', async () => {
            assert.equal (tAssets.toNumber(), 2, "should be 2")
        })
    })

    // describe ('fetch asset by code', async () => {
    //     let result, assetName

    //     before (async () => {
    //         result = await assetmanager.getAssetByCode('vini_code')
    //     })

    //     it ('retrieves the right asset', async () => {
    //         assert.equal (assetName, "test")
    //     })
    // })
})